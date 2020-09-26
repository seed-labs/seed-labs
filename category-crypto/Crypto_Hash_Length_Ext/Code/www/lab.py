from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, current_app as app
)
from werkzeug.exceptions import abort
import os
import hashlib
import urllib.parse
import hmac

bp = Blueprint('lab', __name__)

INVALID_KEY = '-1'


@bp.route('/')
def main():
    # set debug to 1 and show the verbose output
    uid = request.args.get('uid', default=None)
    if not uid:
        return 'UID argument not found. Aborting.'
    app.logger.info('Request received from user %s', uid)

    cmd = get_command()
    app.logger.info(request.args.get('lstcmd').encode('utf-8', 'surrogateescape'))
    download = request.args.get('download', default='', type=str)
    mac = request.args.get('mac', default='', type=str)
    my_name = request.args.get('myname', default='', type=str)

    if not my_name:
        return 'Please include the "myname" argument in the request'

    if not cmd or not mac:
        return 'Please specify a command and its MAC'

    key = find_key(uid)
    if key == INVALID_KEY:
        return 'No key found for this user ' + uid
    valid = verify_mac(key, my_name, uid, cmd, download, mac)
    if not valid:
        return render_template('index.html', valid=False)

    files = []
    if cmd == '1':
        files = list_files()
    content = ''
    if download:
        content = read_file(download)
    return render_template('index.html', valid=True, files=files, content=content)


def find_key(uid):
    path = app.config['LAB_HOME_DIR'] + '/' + app.config['KEY_FILE_NAME']
    if not os.path.exists(path):
        app.logger.error('key file cannot be found')
        return INVALID_KEY
    f = open(path, 'r')
    lines = f.readlines()
    app.logger.debug(path)
    app.logger.debug(lines)
    f.close()
    for line in lines:
        line = line.strip()
        app.logger.debug(line)
        delimiter = app.config['KEY_FILE_DELIMITER']
        if delimiter not in line:
            app.logger.error('invalid line in the key file [delimiter not found]' + line)
            continue
        _uid, _key = line.split(delimiter)
        if _uid == uid:
            return _key
    return INVALID_KEY


def verify_mac(key, my_name, uid, cmd, download, mac):
    download_message = '' if not download else '&download=' + download
    message = ''
    if my_name:
        message = 'myname={}&'.format(my_name)
    message += 'uid={}&lstcmd='.format(uid) + cmd + download_message
    payload = key + ':' + message
    app.logger.debug('payload is [{}]'.format(payload))
    real_mac = hashlib.sha256(payload.encode('utf-8', 'surrogateescape')).hexdigest()
    app.logger.debug('real mac is [{}]'.format(real_mac))
    if mac == real_mac:
        return True
    return False


def list_files():
    return os.listdir(app.config['LAB_HOME_DIR'])


def read_file(file):
    path = app.config['LAB_HOME_DIR'] + '/' + file
    if not path_access_control(path):
        return 'Access Denied'
    if not os.path.exists(path):
        return 'No Such File [{}]'.format(file)
    result = []
    f = open(path, 'r')
    lines = f.readlines()
    for line in lines:
        result.append(line.strip())
    f.close()
    return result


def get_command():
    # parse the value into a string and reserve the unprintable bytes
    query = request.query_string.decode('utf-8', 'surrogateescape')
    if '%' in query:
        query = urllib.parse.unquote(query, errors="surrogateescape")
    pairs = query.split('&')
    for pair in pairs:
        key, value = pair.split('=')
        if key == 'lstcmd':
            return value
    return ''


def path_access_control(path):
    normalized = os.path.normpath(path)
    return os.path.commonprefix([normalized, app.config['LAB_HOME_DIR']]) == app.config['LAB_HOME_DIR']
