#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.clock import Clock
import time
#import MFRC522
#import RPi.GPIO as GPIO
#import signal

class widgetClock(Label):
    def update(self, *args):
        self.text = time.asctime()

class mealsToRegister():
    # methods
    def get():
        mealsToRegisterRequest = requests.get('http://127.0.0.1:5000/meals-to-register')
        if mealsToRegisterRequest.status_code != 200:
            # This means something went wrong.
            raise ApiError('GET /tasks/ {}'.format(mealsToRegisterRequest.status_code))
        return mealsToRegisterRequest.json()

# class registrationModule():
#
#     # methods
#     def getUID():


class TestApp(App):

    def build(self):

        layout = BoxLayout(orientation = 'horizontal')
        layoutDate = BoxLayout(orientation='vertical')
        layoutButtons = BoxLayout(orientation='vertical')

        widgetClock1 = widgetClock()
        Clock.schedule_interval(widgetClock1.update, 1)
        layoutDate.add_widget(widgetClock1)

        mealsToRegister1 = mealsToRegister()
        meals = mealsToRegister.get()

        for meal in meals:
            layoutButtons.add_widget(Button(text=meal['nimetus']))

        # buttonLunch = Button(text="Lõunasöök")
        # buttonAdditional = Button(text="Lisaeine")
        # buttonBreakfast = Button(text="Hommikusöök")
        #
        # layoutButtons.add_widget(buttonLunch)
        # layoutButtons.add_widget(buttonAdditional)
        # layoutButtons.add_widget(buttonBreakfast)

        layout.add_widget(layoutDate)
        layout.add_widget(layoutButtons)

        return layout

if __name__ == '__main__':
    TestApp().run()
