from sys import stderr
import time

class Widget:
    widget_list = {}
    # key: id of widget
    # id is used to remove certain widgets from this list
    # value: Widget instance

    separator = " | "

    def __init__(self, align="l", fg="-", bg="-"):
        self.text = ""
        self.align = align
        self.bg = bg
        self.fg = fg
        id_ = 0
        while True:
            if id_ not in self.__class__.widget_list:
                self.__class__.widget_list[id_] = self
                break
            id_ += 1
        self.id = id_
        self.init()
    
    def init(self): pass # called after __init__, sets variables used by various widgets

    def update(self): pass # updates the text

    def draw(self):
        # returns how the widget should be drawn (fg, bg, alignment etc)
        return "%{F"+self.fg+"}"+"%{B"+self.bg+"}"+self.text+"%{F-}%{B-}"

    @classmethod
    def tick(cls, sleep=None):
        for widget in cls.widget_list.values():
            widget.update()
        
        l = ["%{l}"]
        c = ["%{c}"]
        r = ["%{r}"]

        for widget in cls.widget_list.values():
            a = widget.align
            if a == "l":
                l.append(widget.draw())
            elif a == "c":
                c.append(widget.draw())
            elif a == "r":
                r.append(widget.draw())

        out = ""

        for i in (l, c, r):
            out += i[0]
            m = len(i[1:])-1
            for text, n in zip(i[1:], range(len(i[1:]))):
                out += text
                if n != m:
                    out += cls.separator

        print(out, flush=True)
        if sleep is not None:
            time.sleep(sleep)

