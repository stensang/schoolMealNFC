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

# Payload marshalling

soogikord = api.model('Soogikord', {
    'isikukood' : fields.String('Söögikorra lisaja isikukood (nt "38001010014")'),
    'seisund' : fields.Integer('Söögikorra seisund (nt 0-arhiveeritud, 1-koostamisel, 2-kinnitatud, 3-registreerimine avatud, 4-registreerimine suletud)'),
    'liik' : fields.Integer ('Söögikorra liik (nt 1-hommikusöök, 2-lõunasöök, 3-lisaeine)'),
    'kuupaev' : fields.String ('Söögikorra toimumise kuupäev (nt "2018-02-02")'),
    'vaikimisi' : fields.String ('Kas söögikord on vaikimisi valik? (nt "True"/"False")'),
    'kirjeldus' : fields.String ('Söögikorra kirjeldus (nt "Väga maitsev")'),
})

avatudSoogikorrad = api.model('Registreerimiseks avatud söögikorrad', {
    'soogikorra_id' : fields.Integer,
})

opilaseSoogikorrad = api.model('Õpilase söögikorrad', {
    'uid' : fields.String,
    'soogikorrad' : fields.List(fields.Nested(avatudSoogikorrad)),
})


@api.route('/soogikorrad')
class Soogikorrad(Resource):
    def get(self):

        seisund = request.args.get("seisund")
        db = PGDatabase()

        if seisund is not None:
            db.execute("""
                        SELECT sk.soogikorra_id, sk.nimetus, to_char(sk.kuupaev, 'DD.MM.YYYY') as kuupäev, sk.kirjeldus, sk.vaikimisi, sk.seisund
                        FROM soogikordade_koondtabel sk
                        WHERE seisund = %s
                        LIMIT 30;""", (seisund,))
        else:
            db.execute("""
                        SELECT sk.soogikorra_id, sk.nimetus, to_char(sk.kuupaev, 'DD.MM.YYYY') as kuupäev, sk.kirjeldus, sk.vaikimisi, sk.seisund
                        FROM soogikordade_koondtabel sk
                        LIMIT 100;""", ("",))

        soogikorrad = db.getRecords()
        db.close()
        # No need for jsonify, flask_restplus assumes you return json
        return soogikorrad

    @api.expect(soogikord, validate=True)
    def post(self):
        # Andmete lugemine POST sõnumist
        content = request.json

        isikukood = content['isikukood']
        soogikorra_seisundi_liik_kood = content['seisund']
        soogikorra_liik_kood = content['liik']
        kuupaev = content['kuupaev']
        vaikimisi = content['vaikimisi']
        kirjeldus = content['kirjeldus']

        db = PGDatabase()
        db.execute("""
                    INSERT INTO Soogikord (isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus)
                    VALUES (%s, %s, %s, %s, %s, %s);""",
                    (isikukood, soogikorra_seisundi_liik_kood, soogikorra_liik_kood, kuupaev, vaikimisi, kirjeldus))
        db.commit()
        db.close()

        return {'Tulemus': 'Soogikord lisatud'}, 201

@api.route('/soogikorrad/<int:soogikorra_id>')
class Soogikord(Resource):
    def get(self, soogikorra_id):

        db = PGDatabase()
        db.execute("""
                    SELECT sk.soogikorra_id, sk.nimetus, to_char(sk.kuupaev, 'DD.MM.YYYY') as kuupäev, sk.kirjeldus, sk.vaikimisi, sk.seisund
                    FROM soogikordade_koondtabel sk
                    WHERE soogikorra_id = %s;""", (soogikorra_id,))

        soogikord = db.getRecords()
        db.close()
        return soogikord

    def put(self, soogikorra_id):
        pass

@api.route('/soogikorrad/<int:soogikorra_id>/registreerimised')
class Registreerimised(Resource):
    def get(self, soogikorra_id):

        db = PGDatabase()
        db.execute("""
                    SELECT sk.soogikorra_id, sk.nimetus, to_char(sk.kuupaev, 'DD.MM.YYYY') as kuupäev, sk.kirjeldus, sk.vaikimisi, sk.seisund
                    FROM soogikordade_koondtabel sk
                    WHERE soogikorra_id = %s;""", (soogikorra_id,))

        lunch = db.getRecords()
        lunchDict = lunch[0]

        registrations = []

        db.execute("""SELECT soojate_grupp_kood, nimetus FROM soojate_grupp""", "")
        groups = db.getRecords()


        for group in groups:
            groupDict = {}
            groupDict['sööjate_grupi_nimetus'] = group['nimetus']

            db.execute("""
                        SELECT k.nimetus, k.opilasi_klassis, s.opilasi_registreeritud
                        FROM  Klass_opilasi_klassis k JOIN Soogikorrad_klasside_registreerimised s
                        ON  k.klass_id = s.klass_id
                        WHERE s.soogikorra_id = %s AND k.soojate_grupp_kood= %s
                        """, (lunchDict['soogikorra_id'], group['soojate_grupp_kood']))

            classes = db.getRecords()

            classList = []
            for c in classes:
                classDict = {}
                classDict['nimetus'] = c['nimetus']
                classDict['õpilasi_klassis'] = c['opilasi_klassis']
                classDict['söögikorrale_registreeritud'] = c['opilasi_registreeritud']
                classList.append(classDict)

            groupDict['klassid'] = classList
            registrations.append(groupDict)

        db.close()

        lunchDict['registreerimised'] = registrations
        return lunchDict

@api.route('/opilane/soogikorrad')
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
        # Õpilase ID pärimine kasutades UID, LISADA kontroll, kas õpilase staatus on kehtiv (andmebaasi), või pärida vaadet, kus on kõik aktiivsed õpilased
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

if __name__ == '__main__':
    app.run()
