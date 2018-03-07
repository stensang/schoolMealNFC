from flask import Flask, render_template

# Initialize
app = Flask(__name__) # root path

#App to debug mode - website changes with refresh
app.debug = True

@app.route('/')
def index():
    return render_template('home.html')

@app.route('/about')
def about():
    return render_template('about.html')

# Only run if it is a main file
if __name__ == '__main__':
    app.run(port=5001)
