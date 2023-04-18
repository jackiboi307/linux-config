from time import sleep, time as ms_time
from datetime import datetime
from i3ipc import Connection, Event
from threading import Thread, Condition
from sys import stderr
from psutil import sensors_battery 
from math import floor, ceil
from subprocess import check_output, CalledProcessError, Popen, PIPE
import re
from pylemonlib import Widget

i3 = Connection()

# VARIABLES / CONSTANTS

def get_ms():
    return round(ms_time() * 1000)

lang = "se"

weekSE = "Måndag Tisdag Onsdag Torsdag Fredag Lördag Söndag".split(" ")
weekEN  = "Monday Tuesday Wednesday Thursday Friday Saturday Sunday".split(" ")
week = {"se": weekSE, "en": weekEN}[lang]

monthSE = "Januari Februari Mars April Maj Juni Juli Augusti Oktober September November December".split(" ")
monthEN = "January February Mars April May June July August Oktober September November December".split(" ")
months = {"se": monthSE, "en": monthEN}[lang]

# BUILD / UPDATE

def f(text, fg=None, bg=None):
    if fg is not None:
        text = "%{F"+fg+"}" + text + "%{F-}"
    if bg is not None:
        text = "%{B"+bg+"}" + text + "%{B-}"
    return text

def update():
    global now; now = datetime.now()
    global weekday; weekday = week[now.weekday()]
    global day; day = now.day
    global time; time = f"{now.hour:02d}:{now.minute:02d}"
    global month; month = months[now.month-1]
    global battery_text
    try:
        battery = sensors_battery()
        global secsleft; secsleft = battery.secsleft
        global charging; charging = battery.power_plugged
        global battery_percent; battery_percent = battery.percent
        battery_text = f"{ceil(battery_percent)}% {f('+', '#b8bb26') if charging else f('-', '#fb4934')} "
    except Exception:
        battery_text = "Couldn't retrieve battery"
    global network_name
    global network_strength
    try:
        network_name = check_output(["iwgetid", "-r"]).replace("\n".encode(), "".encode()).decode("utf-8")
        if network_name.isspace():
            network_name = "Not Connected"
            network_strength = ""
        else:
            network_strength = ""

    except CalledProcessError:
        network_name = "Not Connected"
        network_strength = ""

def build():
    global l, c, r
    for w in workspaces:
        l += f(f"{w.name} ", "#83a598" if w.focused else None)
    c += f"{weekday} {day} {month} {time}"
    r += f"Network: {network_name} {network_strength}| "
    r += battery_text

# i3 INTERACTION

def on_workspace_focus(self, e):
    global workspaces, next_ms
    workspaces = i3.get_workspaces()
    update_and_draw()

i3.on(Event.WORKSPACE_FOCUS, on_workspace_focus)

class i3T(Thread):
    def run(self):
        i3.main()

i3t = i3T()
i3t.daemon = True
i3t.start()

workspaces = i3.get_workspaces()

# LOOP

def update_and_draw():
    global l, c, r
    update()
    l = ""
    c = ""
    r = ""
    build()
    print("%{l}"+l+"%{c}"+c+"%{r}"+r, flush=True)

try:
    while True:
        update_and_draw()
        sleep(1)
except KeyboardInterrupt:
    print("\nExits...", file=stderr, end="\n")
    i3.main_quit()
    i3t.join()

