#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask, request, jsonify
from flask_restplus import Resource, Api
from database import PGDatabase
import sys


app = Flask(__name__)
api = Api(app)

#App to debug mode - website changes with refresh
app.debug = True
app.config['JSON_AS_ASCII'] = False

@api.route('/hello')
class Helloworld(Resource):
    def get(self):
        return {'hello':'world'}

@api.route('/opilase-soogikorrad')
class OpilaseSoogikorrad(Resource):
    def put(self):
        opilase_soogikorrad = request.form['data']
        return {soogikorra_ID: opilase_soogikorrad[soogikorra_ID]}

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

@api.route('/meals-to-register')
class MealsToRegister(Resource):
    def get(self):
        db = PGDatabase()
        mealstToRegisterData = db.execute("SELECT * FROM Soogikorrad_registreerimisele_avatud LIMIT 3")
        db.close()
        return jsonify(mealstToRegisterData)

    # {
	# 			[
	# 				{ "soogikorra_id": "2", "nimetus": "Lõunasöök" },
	# 				{ "soogikorra_id": "3", "nimetus": "Lisaeine" },
	# 				{ "soogikorra_id": "1", "nimetus": "Hommikusöök" }
	# 			]
    # }

if __name__ == '__main__':
    app.run()
