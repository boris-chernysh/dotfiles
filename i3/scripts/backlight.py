#!/usr/bin/env python

from subprocess import (check_output)

backlightLevel = round(float(check_output(["xbacklight"])))

print("%(backlightLevel)s%%" % locals())
