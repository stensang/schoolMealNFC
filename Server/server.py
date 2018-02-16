#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask, jsonify, request

app = Flask(__name__)

#App to debug mode - website changes with refresh
app.debug = True
app.config['JSON_AS_ASCII'] = False

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

@app.route('/meals-to-register', methods=['GET'])
def test4():
    return jsonify({
	"mealsToRegister":
				[
					{ "id": "2", "name": "Lõunasöök" },
					{ "id": "3", "name": "Lisaeine" },
					{ "id": "1", "name": "Hommikusöök" }
				]
                })

if __name__ == '__main__':
    app.run()
