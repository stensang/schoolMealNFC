#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2

class PGDatabase():
    def __init__(self):
        #Define our connection string
        self.conn_string = "host='localhost' dbname='postgres' user='postgres' password='postgres'"
        # print the connection string we will use to connect
        print("Connecting to database\n	->%s" % (self.conn_string))
        # get a connection, if a connect cannot be made an exception will be raised here
        self.conn = psycopg2.connect(self.conn_string)
        # conn.cursor will return a cursor object, you can use this cursor to perform queries
        self.cursor = self.conn.cursor()
        print("Connected!\n")

    def execute(self, query):
        self.cursor.execute(query)
        # "SELECT * FROM Soogikorrad_registreerimisele_avatud LIMIT 3"
        self.records = self.cursor.fetchall()
        self.records_list = []
        for self.r in self.records:
            self.dictionary = {}
            self.column = 0
            for self.item in self.r:
                self.dictionary[self.cursor.description[self.column][0]] = self.item
                self.column +=1
            self.records_list.append(self.dictionary)
        return self.records_list

    def close(self):
        self.cursor.close()
        self.conn.close()
