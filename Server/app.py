#!/usr/bin/env python
# -*- coding: utf-8 -*-

# http://flask.pocoo.org/
from flask import Flask, request, jsonify
# http://flask-restplus.readthedocs.io/en/stable/
from flask_restplus import Api, Resource, fields
import datetime
import sys
from database import PGDatabase

# Initialize
app = Flask(__name__)
api = Api(app)

# App to debug mode - website changes with refresh
app.debug = True
# app.config['JSON_AS_ASCII'] = False

# Response marshalling
avatudSoogikorrad = api.model('Registreerimiseks avatud söögikorrad', {
    'soogikorra_id' : fields.Integer,
})
opilaseSoogikorrad = api.model('Õpilase söögikorrad', {
    'uid' : fields.String,
    'soogikorrad' : fields.List(fields.Nested(avatudSoogikorrad)),
})

@api.route('/opilase-soogikorrad')
# Inherit from Resource
class OpilaseSoogikorrad(Resource):
    def get(self):
        return {'This': 'Works'}

    # Informatsiooni valideerimine
    @api.expect(opilaseSoogikorrad, validate=True)
    def post(self):
        # Andmete lugemine POST sõnumist
        content = request.json
        uid = content['uid']
        soogikorrad = content['soogikorrad']

        # Andmebaasi ühenduse avamine
        db = PGDatabase()
        # Õpilase ID pärimine kasutades UID
        db.execute("""SELECT opilane_ID FROM Opilane WHERE UID= %s ;""", (uid,))
        records = db.getRecords()
        # LISADA: Kontrolli, kas tagastatakse ID, kui ei, siis sellise UID-ga õpilast ei ole. Sulge ühendus.
        opilase_id = records[0]['opilane_id']

        # Andmete sisestamine Andmebaasi
        for soogikord in soogikorrad:
            db.execute("""INSERT INTO Opilase_soogikorrad (soogikorra_ID, opilane_ID, registreerimise_kuupaev) VALUES (%s, %s, %s);""",
            (soogikord['soogikorra_id'], opilase_id, datetime.date.today() ))

        # Andmete kinnitamine
        db.commit()
        # Ühenduse sulgemine
        db.close()


@api.route('/soogikorrad-registreerimisele-avatud')
class MealsToRegister(Resource):
    def get(self):
        db = PGDatabase()
        db.execute("""SELECT * FROM Soogikorrad_registreerimisele_avatud LIMIT 3""", "")
        mealstToRegisterData = db.getRecords()
        db.close()
        # No need for jsonify, flask_restplus assumes you return jsonify
        return mealstToRegisterData

if __name__ == '__main__':
    app.run()
