from flask import (
    Blueprint, Flask, redirect, render_template, request, url_for, current_app as app, json
)
import flask


bp = Blueprint('iot', __name__)


@bp.route('/password', methods=('GET',))
def password():
    data = {
        'password': app.password
    }
    return app.response_class(
        response=json.dumps(data),
        mimetype='application/json; charset=utf-8'
    )


@bp.route('/', methods=('GET',))
def index():
    return render_template('index.html')

@bp.route('/change', methods=('GET',))
def change():
    return render_template('change.html')

@bp.route('/temperature', methods=('GET',))
def get_temperature():
    data = {
        'temperature': app.temperature
    }

    response = app.response_class(
        response=json.dumps(data),
        mimetype='application/json; charset=utf-8'
    )
    return response


@bp.route('/temperature', methods=('POST',))
def set_temperature():
    l_password = request.args.get('password', None)
    if l_password != app.password:
        return app.response_class(
            response='wrong password',
            status=401
        )
    temperature = request.args.get('value', None)
    if not temperature:
        return app.response_class(
            response='not value',
            status=400,
            mimetype='text/plain'
        )
    temperature = int(temperature)
    if app.config['LOWEST'] <= temperature <= app.config['HIGHEST']:
        app.temperature = temperature
        data = {'temperature': temperature}
        return app.response_class(
            response=json.dumps(data),
            mimetype='application/json; charset=utf-8'
        )
    else:
        return app.response_class(
            response='temperature out of bound',
            status=400,
            mimetype='text/plain'
        )
