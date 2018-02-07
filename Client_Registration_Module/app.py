#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.clock import Clock

import time

class widgetClock(Label):
    def update(self, *args):
        self.text = time.asctime()


class TestApp(App):

    def build(self):

        mealsToRegisterRequest = requests.get('http://127.0.0.1:5000/meals-to-register')
        if mealsToRegisterRequest.status_code != 200:
            # This means something went wrong.
            raise ApiError('GET /tasks/ {}'.format(mealsToRegisterRequest.status_code))

        mealsToRegister = mealsToRegisterRequest.json()

        layout = BoxLayout(orientation = 'horizontal')
        layoutDate = BoxLayout(orientation='vertical')
        layoutButtons = BoxLayout(orientation='vertical')

        widgetClock1 = widgetClock()
        Clock.schedule_interval(widgetClock1.update, 1)
        layoutDate.add_widget(widgetClock1)

        for meal in mealsToRegister["mealsToRegister"]:
            layoutButtons.add_widget(Button(text=meal['name']))

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
