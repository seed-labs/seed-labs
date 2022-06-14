import os

from flask import Flask
from .config import Config


def create_app(test_config=None):
	# create and configure the app
	app = Flask(__name__, instance_relative_config=True)
	
	if test_config is None:
		app.config.from_object(Config)
	else:
		app.config.from_mapping(test_config)

	paths = [app.config['LAB_HOME_DIR']]
	for path in paths:
		if not os.path.exists(path):
			os.makedirs(path)
	init_keys(app)
	init_files(app)

	@app.route('/hello')
	def hello():
		return 'Hello, World!'

	from . import lab
	app.register_blueprint(lab.bp)
	app.add_url_rule('/', endpoint='index')

	return app


def init_keys(app):
	path = app.config['LAB_HOME_DIR'] + '/' + app.config['KEY_FILE_NAME']
	if not os.path.exists(path):
		f = open(path, 'w')
		f.write('{}:{}\n'.format(app.config['DEFAULT_USER_ID'], app.config['DEFAULT_USER_KEY']))
		f.close()


def init_files(app):
	path = app.config['LAB_HOME_DIR'] + '/' + app.config['DUMMY_FILE']
	if not os.path.exists(path):
		f = open(path, 'w')
		f.write('Congratulations! You get the MAC right.')
		f.close()
