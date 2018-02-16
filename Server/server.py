#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask, jsonify, request
import psycopg2
import sys

def getMealsToRegister():
    #Define our connection string
    conn_string = "host='localhost' dbname='postgres' user='postgres' password='postgres'"

    # print the connection string we will use to connect
    print("Connecting to database\n	->%s" % (conn_string))

    # get a connection, if a connect cannot be made an exception will be raised here
    conn = psycopg2.connect(conn_string)

    # conn.cursor will return a cursor object, you can use this cursor to perform queries
    cursor = conn.cursor()
    print("Connected!\n")

    cursor.execute("SELECT * FROM Soogikorrad_registreerimisele_avatud LIMIT 3")
    records = cursor.fetchall()

    records_list = []

    for r in records:
        dictionary = {}
        column = 0
        for item in r:
            dictionary[cursor.description[column][0]] = item
            column +=1
        records_list.append(dictionary)

    return records_list



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
def mealsToRegister():
    mealstToRegisterData = getMealsToRegister()
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
