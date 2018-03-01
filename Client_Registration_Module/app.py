#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.boxlayout import BoxLayout
from kivy.clock import Clock, mainthread
import threading
import time
import signal
import MFRC522

class widgetClock(Label):
    def update(self, *args):
        self.text = time.asctime()

class mealsToRegister():
    # variables
    getUrl = 'http://192.168.1.186:5000/soogikorrad-registreerimisele-avatud'
    postUrl = 'http://192.168.1.186:5000/opilase-soogikorrad'

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

class nfcReader(Label):

    mr = mealsToRegister()

    def update(self, *args):

        self.text = "Näita kaarti!"
        # Create an object of the class MFRC522
        self.MIFAREReader = MFRC522.MFRC522()

        # Scan for cards
        (self.status,self.TagType) = self.MIFAREReader.MFRC522_Request(self.MIFAREReader.PICC_REQIDL)

        # If a card is found
        if self.status == self.MIFAREReader.MI_OK:
            print("Card detected")

        # Get the UID of the card
        (self.status, uid) = self.MIFAREReader.MFRC522_Anticoll()

        # If we have the UID, continue
        if self.status == self.MIFAREReader.MI_OK:

            uidSTR = ''.join(map(str, uid))
            self.text = uidSTR

            # Testin API-t
            self.data = {'uid': uidSTR, 'soogikorrad': [{'soogikorra_id': 1}, {'soogikorra_id': 2}, {'soogikorra_id': 3}]}
            self.mr.post(self.data)

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

        nfc = nfcReader()

        Clock.schedule_interval(nfc.update, 0.5)
        layoutDate.add_widget(nfc)

        # rs = registrationStatus()
        # Clock.schedule_interval(rs.update, 1)
        # layoutDate.add_widget(rs)

        layout.add_widget(layoutDate)
        layout.add_widget(layoutButtons)

        return layout

if __name__ == '__main__':
    TestApp().run()
