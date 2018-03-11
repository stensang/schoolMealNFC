import requests
from flask import Flask, render_template

# Initialize
app = Flask(__name__) # root path

#App to debug mode - website changes with refresh
app.debug = True

@app.route('/lunch')
def data():
    lunchData = requests.get('http://127.0.0.1:5000/lounasook/2018-02-16')
    return render_template('data.html', lunch=lunchData.json())

@app.route('/meals')
def about():
    return render_template('meals.html')

# Only run if it is a main file
if __name__ == '__main__':
    app.run(port=5001)
