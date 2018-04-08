#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.label import Label
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.boxlayout import BoxLayout
from kivy.clock import Clock
from kivy.uix.screenmanager import ScreenManager, Screen, NoTransition
import time
import MFRC522
import RPi.GPIO as GPIO

class AvailableMeals():
    '''DESCRIPTON'''

    def __init__(self):
        '''DESCRIPTON'''

        self.URL = 'https://35.204.17.63:8080/soogikorrad?seisund=Registreerimine%20avatud'

    def get(self):
        '''DESCRIPTON'''

        self.getResponse = requests.get(self.URL, verify=False, auth=('eino.opik@epost.ee', 'P@ssw0rd!'))
        return self.getResponse.json()

class RegisterMeals():
    '''DESCRIPTON'''

    def __init__(self):
        '''DESCRIPTON'''

        self.URL = 'https://35.204.17.63:8080/opilased/registreerimised'

    def register(self, payload):
        '''DESCRIPTON'''

        self.postResponse = requests.post(self.URL, verify=False, json = payload, auth=('eino.opik@epost.ee', 'P@ssw0rd!'))
        return self.postResponse

class RfidReader():
    '''DESCRIPTON'''

    def __init__(self):
        '''DESCRIPTON'''

        # Create an object of the class MFRC522
        self.MIFAREReader = MFRC522.MFRC522()

    def getUID(self, *args):
        '''DESCRIPTON'''

        # Scan for cards
        (self.status,self.TagType) = self.MIFAREReader.MFRC522_Request(self.MIFAREReader.PICC_REQIDL)

        # Get the UID of the card
        (self.status, uid) = self.MIFAREReader.MFRC522_Anticoll()

        # If we have the UID, continue
        if self.status == self.MIFAREReader.MI_OK:

            # Join UID to string and return
            uidSTR =  str(hex(uid[0]) [2:]) + ':' + str(hex(uid[1]) [2:])  + ':' + str(hex(uid[2]) [2:])  + ':' + str(hex(uid[3]) [2:])
            return uidSTR


class RegistrationHandler():
    '''DESCRIPTON'''

    def __init__(self):
        '''DESCRIPTON'''

        self.nfc = RfidReader()
        self.rm = RegisterMeals()

    def update(self, *args):
        '''DESCRIPTON'''

        if RaspberryPi.sm.current != 'main':
            time.sleep(1)
            RaspberryPi.sm.current = 'main'

        self.uidSTR = self.nfc.getUID()

        if self.uidSTR is not None:

            self.data = {}
            self.data['uid'] = self.uidSTR
            self.data['soogikorrad'] = RaspberryPi.ms.getCheckedMeals()

            registerResponse = self.rm.register(self.data)

            if  registerResponse.status_code == 202:
                RaspberryPi.rs.setResponseText(registerResponse.text)
            else:
                RaspberryPi.rs.setResponseText(registerResponse.text)

            RaspberryPi.sm.current = 'response'


class MToggleButton(ToggleButton):
    soogikorra_id=""

class Meals(BoxLayout):
    '''DESCRIPTON'''

    def __init__(self, **kwargs):
        '''DESCRIPTON'''

        super(Meals, self).__init__(**kwargs)

        am = AvailableMeals()
        meals = am.get()

        for meal in meals:
            button = MToggleButton(
            font_size = 32,
            text=meal['liik']+' ('+meal[u'kuupäev']+')',
            state= 'down' if meal['vaikimisi'] else 'normal')

            button.soogikorra_id = meal['soogikorra_id']
            self.add_widget(button)


class MainScreen(Screen):
    '''DESCRIPTON'''

    def __init__(self, **kwargs):
        '''DESCRIPTON'''

        super(MainScreen, self).__init__(**kwargs)
        self.name = 'main'

        self.layoutMeals = Meals(orientation='vertical')
        self.add_widget(self.layoutMeals)

    def getCheckedMeals(self):
        '''DESCRIPTON'''

        self.checkedMeals = []
        for self.meal in self.layoutMeals.children:
            if self.meal.state=='down':
                self.d = {}
                self.d['soogikorra_id'] = self.meal.soogikorra_id
                self.checkedMeals.append(self.d)

        return self.checkedMeals

class ResponseScreen(Screen):
    '''DESCRIPTON'''

    def __init__(self, **kwargs):
        '''DESCRIPTON'''

        super(ResponseScreen, self).__init__(**kwargs)
        self.name = 'response'
        self.responseLabel = Label(font_size=32)
        self.add_widget(self.responseLabel)

    def setResponseText(self, t):
        self.responseLabel.text = t

class RaspberryPi(App):
    '''DESCRIPTON'''

    sm = ScreenManager(transition=NoTransition())
    ms = MainScreen()
    rs = ResponseScreen()

    def build(self):
        '''DESCRIPTON'''

        self.sm.add_widget(self.ms)
        self.sm.add_widget(self.rs)

        self.rh = RegistrationHandler()
        Clock.schedule_interval(self.rh.update, 0.75)

        return self.sm

if __name__ == '__main__':

    try:
        RaspberryPi().run()

    except KeyboardInterrupt:

        print("Programmi sulgemine")

    except Exception, error:

        print str(error)

    finally:
        GPIO.cleanup()
