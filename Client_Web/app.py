import requests
from datetime import datetime
from flask import Flask, render_template, request, flash, redirect
from flask_wtf import FlaskForm
from wtforms import Form, StringField, BooleanField, SubmitField, DateField, TextAreaField, SelectField, validators

# Initialize
app = Flask(__name__) # root path
app.config['SECRET_KEY'] = 'olen-v2ga-salajane'

#App to debug mode - website changes with refresh
app.debug = True

class SoogikorraMuutmiseVorm(FlaskForm):
    seisundid = requests.get('http://127.0.0.1:5000/soogikorrad/seisundid')
    seisundid_dict = seisundid.json()
    liigid = requests.get('http://127.0.0.1:5000/soogikorrad/liigid')
    liigid_dict = liigid.json()

    # https://wtforms.readthedocs.io/en/stable/crash_course.html#download-installation
    seisund = SelectField('Seisund', coerce=int, choices=[(seisund['kood'], seisund['nimetus']) for seisund in seisundid_dict])
    liik = SelectField('Liik', coerce=int, choices=[(liik['kood'], liik['nimetus']) for liik in liigid_dict])
    kuupaev = DateField('Kuupäev')
    kirjeldus = TextAreaField('Kirjeldus')

class SoogikorraSisestamiseVorm(SoogikorraMuutmiseVorm):
    isikukood = StringField('Isikukood')

@app.route('/')
@app.route('/soogikorrad')
def soogikorrad():
    andmed = requests.get('http://127.0.0.1:5000/soogikorrad')
    return render_template('soogikorrad.html', soogikorrad=andmed.json())

@app.route('/soogikorrad/lisa', methods = ('GET', 'POST'))
def lisaSoogikord():

    vorm = SoogikorraSisestamiseVorm()

    if vorm.validate_on_submit():

        payload = {}
        payload['isikukood'] = vorm.isikukood.data
        payload['seisund'] = vorm.seisund.data
        payload['liik'] = vorm.liik.data
        payload['kuupäev'] = '{:%Y-%m-%d}'.format(vorm.kuupaev.data)
        payload['vaikimisi'] = 'True' if vorm.liik.data == 2 else 'False'
        payload['kirjeldus'] = vorm.kirjeldus.data
        # print(payload)
        request = requests.post('http://127.0.0.1:5000/soogikorrad', json = payload)

        return redirect('/')

    print(vorm.errors)
    return render_template('soogikorra-lisamine.html', vorm=vorm)

@app.route('/soogikorrad/<string:id>/registreerimised')
def soogikorraRegistreerimised(id="1"):
    andmed = requests.get('http://127.0.0.1:5000/soogikorrad/' + id + '/registreerimised')
    return render_template('soogikorra-registreerimised.html', soogikorraAndmed=andmed.json())

@app.route('/soogikorrad/muuda/<string:id>', methods = ['POST'])
def muudaSoogikord(id):

    vorm = SoogikorraMuutmiseVorm()
    if vorm.validate_on_submit():

        payload = {}
        payload['seisund'] = vorm.seisund.data
        payload['liik'] = vorm.liik.data
        payload['kuupäev'] = '{:%Y-%m-%d}'.format(vorm.kuupaev.data)
        payload['vaikimisi'] = 'True' if vorm.liik.data == 2 else 'False'
        payload['kirjeldus'] = vorm.kirjeldus.data
        request = requests.put('http://127.0.0.1:5000/soogikorrad/' + id, json = payload)

        return redirect('/')

    print(vorm.errors)
    return render_template('soogikorra-muutmine.html', vorm=vorm, id=id)

@app.route('/soogikorrad/kustuta/<string:id>', methods = ['POST'])
def kustutaSoogikord(id):
    request = requests.delete('http://127.0.0.1:5000/soogikorrad/' + id)
    return redirect('/')

@app.route('/opilased')
def opilased():
    andmed = requests.get('http://127.0.0.1:5000/opilased')
    return render_template('opilased.html', opilased=andmed.json())

@app.route('/opilased/<string:id>/registreerimised')
def opilaseRegistreerimised(id):
    andmed = requests.get('http://127.0.0.1:5000/opilased/' + id + '/registreerimised')
    print(andmed)
    return render_template('opilase-registreerimised.html', opilaseAndmed=andmed.json())

# Only run if it is a main file
if __name__ == '__main__':
    app.run(port=5001)
