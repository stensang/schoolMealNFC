#!/usr/bin/env python
# -*- coding: utf-8 -*-

import psycopg2

class PGDatabase():
    def __init__(self):
        #Define our connection string
        self.conn_string = "host='localhost' dbname='postgres' user='postgres' password='postgres'"
        # get a connection, if a connect cannot be made an exception will be raised here
        self.conn = psycopg2.connect(self.conn_string)
        # conn.cursor will return a cursor object, you can use this cursor to perform queries
        self.cursor = self.conn.cursor()

    def execute(self, query, data):
        self.cursor.execute(query, data)


    def getRecords(self):
        # "SELECT * FROM Soogikorrad_registreerimisele_avatud LIMIT 3"
        self.records = self.cursor.fetchall()
        self.records_list = []
        for self.r in self.records:
            self.dictionary = {}
            for self.i, self.item in enumerate(self.r):
                self.dictionary[self.cursor.description[self.i][0]] = self.item
            self.records_list.append(self.dictionary)
        return self.records_list

    def commit(self):
        self.conn.commit()

    def close(self):
        self.cursor.close()
        self.conn.close()
