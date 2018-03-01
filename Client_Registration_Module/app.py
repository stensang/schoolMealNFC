#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.boxlayout import BoxLayout
from kivy.clock import Clock
import time
import signal
# import MFRC522

class widgetClock(Label):
    def update(self, *args):
        self.text = time.asctime()

class mealsToRegister():
    # variables
    getUrl = 'http://127.0.0.1:5000/soogikorrad-registreerimisele-avatud'
    postUrl = 'http://127.0.0.1:5000/opilase-soogikorrad'

    # methods
    # Pärib andmeid serverist
    def get(self):
        self.getResponse = requests.get(self.getUrl)
        if self.getResponse.status_code != 200:
            # This means something went wrong.
            raise ApiError('GET /tasks/ {}'.format(self.mealsToRegisterRequest.status_code))
        return self.getResponse.json()
    # Saadab andmed serverile
    def post(self, payload):
        self.postResponse = requests.post(self.postUrl, json = payload)
        return self.postResponse

class nfcReader():
    # methods
    def getUID(self):

        # Hook the SIGINT
        # signal.signal(signal.SIGINT, end_read)

        # Create an object of the class MFRC522
        self.MIFAREReader = MFRC522.MFRC522()

        # Scan for cards
        (self.status,self.TagType) = self.MIFAREReader.MFRC522_Request(self.MIFAREReader.PICC_REQIDL)

        # If a card is found
        if self.status == self.MIFAREReader.MI_OK:
            print("Card detected")

        # Get the UID of the card
        (self.status,self.uid) = self.MIFAREReader.MFRC522_Anticoll()

        # If we have the UID, continue
        if self.status == self.MIFAREReader.MI_OK:

            self.uidSTR = ''.join(map(str, self.uid))

            # return UID
            self.mr = mealsToRegister()
            return self.uidSTR


class registration():
    def update(self, *args):
        self.nfc = nfcReader()
        self.uid = self.nfc.getUID()
        if self.uid is not None:
	    self.mr = mealsToRegister()
            self.data = {'uid': self.uid, 'soogikorrad': [{'soogikorra_id': 1}, {'soogikorra_id': 2}, {'soogikorra_id': 3}]}
            self.mr.post(self.data)
            return self.uid

class registrationStatus(Label):
    def update(self, *args):
    	self.reg = registration()
    	if self.reg.update() is not None:
    	    self.text = self.reg.update()
    	else:
    	    self.text = 'Blaa blaa blaa'


class TestApp(App):

    def build(self):

        layout = BoxLayout(orientation = 'horizontal')
        layoutDate = BoxLayout(orientation='vertical')
        layoutButtons = BoxLayout(orientation='vertical')

        widgetClock1 = widgetClock()
        Clock.schedule_interval(widgetClock1.update, 1)
        layoutDate.add_widget(widgetClock1)

        mealsToRegister1 = mealsToRegister()
        meals = mealsToRegister1.get()

        for meal in meals:
            layoutButtons.add_widget(ToggleButton(text=meal['nimetus'], state= 'down' if meal['vaikimisi'] else 'normal'))

        rs = registrationStatus()
        Clock.schedule_interval(rs.update, 1)
        layoutDate.add_widget(rs)

        layout.add_widget(layoutDate)
        layout.add_widget(layoutButtons)

        return layout

if __name__ == '__main__':
    TestApp().run()
