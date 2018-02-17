#!/usr/bin/env python

from time import sleep
from subprocess import Popen, PIPE
from sys import exit

try:
    process = Popen(["xbacklight"], stdout=PIPE, stderr=PIPE)
    output, err = process.communicate()
except Exception:
    print('error')
    exit(33)

if len(err):
    print(err)
    exit(0)

sleep(0.1)

backlight_level = round(float(output))

print("%(backlight_level)s%%" % locals())
