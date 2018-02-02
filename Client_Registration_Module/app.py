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

        layout = BoxLayout(orientation = 'horizontal')
        layoutDate = BoxLayout(orientation='vertical')
        layoutButtons = BoxLayout(orientation='vertical')

        widgetClock1 = widgetClock()
        Clock.schedule_interval(widgetClock1.update, 1)
        layoutDate.add_widget(widgetClock1)

        buttonLunch = Button(text="Lõunasöök")
        buttonAdditional = Button(text="Lisaeine")
        buttonBreakfast = Button(text="Hommikusöök")

        layoutButtons.add_widget(buttonLunch)
        layoutButtons.add_widget(buttonAdditional)
        layoutButtons.add_widget(buttonBreakfast)

        layout.add_widget(layoutDate)
        layout.add_widget(layoutButtons)

        return layout

if __name__ == '__main__':
    TestApp().run()
