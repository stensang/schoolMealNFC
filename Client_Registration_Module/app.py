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
import signal
import MFRC522

class widgetClock(Label):
    def update(self, *args):
        self.text = time.asctime()

class AvailableMeals():
    # variables
    getUrl = 'http://192.168.1.186:5000/soogikorrad-registreerimisele-avatud'
    postUrl = 'http://192.168.1.186:5000/opilase-soogikorrad'

    # methods
    # Pärib andmeid serverist
    def get(self):
        self.getResponse = requests.get(self.getUrl)
        if self.getResponse.status_code != 200:
            # This means something went wrong.
            raise ApiError('GET /tasks/ {}'.format(self.AvailableMealsRequest.status_code))
        return self.getResponse.json()
    # Saadab andmed serverile
    def register(self, payload):
        self.postResponse = requests.post(self.postUrl, json = payload)
        return self.postResponse

class CardReader():

    #am = AvailableMeals()

    # Create an object of the class MFRC522
    MIFAREReader = MFRC522.MFRC522()

    def getUID(self, *args):

        # Scan for cards
        (self.status,self.TagType) = self.MIFAREReader.MFRC522_Request(self.MIFAREReader.PICC_REQIDL)

        # Get the UID of the card
        (self.status, uid) = self.MIFAREReader.MFRC522_Anticoll()

        # If we have the UID, continue
        if self.status == self.MIFAREReader.MI_OK:

            uidSTR = ''.join(map(str, uid))

            # Testin API-t
            # self.data = {'uid': uidSTR, 'soogikorrad': [{'soogikorra_id': 1}, {'soogikorra_id': 2}, {'soogikorra_id': 3}]}
            # self.am.register(self.data)

            return uidSTR

class CardUID(Label):

    nfc = CardReader()

    def update(self, *args):
        if RaspberryPi.sm.current != 'main':
            time.sleep(0.5)
            RaspberryPi.sm.current = 'main'
        self.text = "Näita kaarti!"
        self.uidSTR = self.nfc.getUID()
        if self.uidSTR is not None:
            RaspberryPi.sm.current = 'response'
            #self.text = self.uidSTR

class Meals(BoxLayout):

    def __init__(self, **kwargs):
        super(Meals, self).__init__(**kwargs)

        am = AvailableMeals()
        meals = am.get()

        for meal in meals:
            self.add_widget(ToggleButton(text=meal['nimetus'], state= 'down' if meal['vaikimisi'] else 'normal'))

class Registrator(BoxLayout):

    def __init__(self, **kwargs):
        super(Registrator, self).__init__(**kwargs)

        self.layoutDate = BoxLayout(orientation='vertical')
        self.layoutMeals = Meals(orientation='vertical')

        self.widgetClock1 = widgetClock()
        Clock.schedule_interval(self.widgetClock1.update, 1)
        self.layoutDate.add_widget(self.widgetClock1)

        self.cardUID = CardUID()

        Clock.schedule_interval(self.cardUID.update, 0.5)
        self.layoutDate.add_widget(self.cardUID)

        self.add_widget(self.layoutDate)
        self.add_widget(self.layoutMeals)


class RaspberryPi(App):

    sm = ScreenManager(transition=NoTransition())

    def build(self):

        self.ms = Screen(name='main')
        self.rt = Registrator()
        self.ms.add_widget(self.rt)

        self.rs = Screen(name='response')
        self.rs.add_widget(Label(text='Hello world!'))

        self.sm.add_widget(self.ms)
        self.sm.add_widget(self.rs)

        return self.sm

if __name__ == '__main__':
    RaspberryPi().run()
