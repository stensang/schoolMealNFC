import requests
from flask import Flask, render_template, request

from wtforms import Form, StringField, PasswordField, BooleanField, SubmitField, validators

# Initialize
app = Flask(__name__) # root path
app.config['SECRET_KEY'] = 'olen-väga-salajane'

#App to debug mode - website changes with refresh
app.debug = True

class SoogikorraSisestamiseVorm(Form):
    # Teha ümber nii, et luuakse itereerides
    # https://wtforms.readthedocs.io/en/stable/crash_course.html#download-installation
    isikukood = StringField('Isikukood', [validators.InputRequired()])
    seisund = StringField('Seisund', [validators.InputRequired()])
    liik = StringField('Liik', [validators.InputRequired()])
    kuupaev = StringField('Kuupäev', [validators.InputRequired()])
    vaikimisi = StringField('Vaikimisi', [validators.InputRequired()])
    kirjeldus = StringField('Kirjeldus', [validators.InputRequired()])

@app.route('/soogikorrad/lisa', methods = ['GET', 'POST'])
def lisaSoogikord():
    vorm = SoogikorraSisestamiseVorm(request.form)

    if request.method == 'POST' and form.validate():
        payload = {}
        payload['isikukood'] = vorm.isikukood.data
        payload['seisund'] = vorm.seisund.data
        payload['liik'] = vorm.liik.data
        payload['kuupaev'] = vorm.kuupaev.data
        payload['vaikimisi'] = vorm.vaikimisi.data
        payload['kirjeldus'] = vorm.kirjeldus.data

    return render_template('meals.html', vorm=vorm)

@app.route('/')
@app.route('/soogikorrad/<string:id>/registreerimised')
def soogikord(id="1"):
    andmed = requests.get('http://127.0.0.1:5000/soogikorrad/' + id + '/registreerimised')
    return render_template('data.html', soogikorraAndmed=andmed.json())

@app.route('/meals')
def about():
    return render_template('meals.html')


# Only run if it is a main file
if __name__ == '__main__':
    app.run(port=5001)
