from flask import Flask, jsonify, request

app = Flask(__name__)

#App to debug mode - website changes with refresh
app.debug = True

@app.route('/', methods=['GET'])
def test():
    return jsonify({'message' : 'It works!'})

@app.route('/breakfasts', methods=['GET'])
def test1():
    return jsonify({'message' : 'breakfasts'})

@app.route('/lunches', methods=['GET'])
def test2():
    return jsonify({'message' : 'lunches!'})

@app.route('/additional-meals', methods=['GET'])
def test3():
    return jsonify({'message' : 'additional-meals!'})

if __name__ == '__main__':
    app.run()
