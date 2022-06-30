from flask import *

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/addTodo', methods = ['POST'])
def addTodo():
   if request.method == 'POST':
      todo = request.form['todo']
      return todo
