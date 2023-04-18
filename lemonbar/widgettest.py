from pylemonlib import Widget
from random import randint as rand, choice
from time import sleep

class RandomCat(Widget):
    def __init__(self):
        super().__init__("l", fg="#CCDDAA")

    def update(self):
        self.text = choice("Sigge Bonzo Bamse Hero Ischmahata Sylvester Blixten Sixten".split())

class RandomNum(Widget):
    def __init__(self):
        super().__init__("c", fg="#FF0000")

    def update(self):
        self.text = str(rand(-100, 100))

RandomCat()
RandomNum()

while True:
    Widget.tick()
    sleep(1)

