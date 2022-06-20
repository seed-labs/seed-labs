from flask import Flask, send_from_directory
from .config import Config
import random as r


def create_app(test_config=None):
	# create and configure the app
	app = Flask(__name__, instance_relative_config=True, static_url_path='')
	
	if test_config is None:
		app.config.from_object(Config)
	else:
		app.config.from_mapping(test_config)

	# configure default temperature
	app.temperature = app.config['DEFAULT_TEMPERATURE']
	# configure IoT password
	app.password = app.config['PASSWORD'] + str(r.random())

	@app.route('/js/<path:path>')
	def send_js(path):
		return send_from_directory('templates/js', path)

	@app.route('/css/<path:path>')
	def send_css(path):
		return send_from_directory('templates/css', path)

	from . import iot
	app.register_blueprint(iot.bp)
	return app
