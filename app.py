from flask import Flask

app = Flask(__name__)

#App to debug mode - website changes with refresh
app.debug = True

@app.route('/')
def index():
    return 'INDEX3'

if __name__ == '__main__':
    app.run()
