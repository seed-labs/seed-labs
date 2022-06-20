from flask import Flask, send_from_directory, render_template

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True, static_url_path='')

    if test_config is None:
        # app.config.from_object(Config)
        pass
    else:
        app.config.from_mapping(test_config)

    @app.route('/js/<path:path>')
    def send_js(path):
        return send_from_directory('templates/js', path)

    @app.route('/css/<path:path>')
    def send_css(path):
        return send_from_directory('templates/css', path)

    @app.route('/')
    def home():
        return render_template('index.html')

    @app.route('/change')
    def change():
        return render_template('change.html')

    @app.route('/password', methods=('GET',))
    def password():
        return 'StillMe'

    return app
