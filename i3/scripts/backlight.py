#!/usr/bin/env python

from time import (sleep)
from subprocess import (check_output)

sleep(0.1)

backlightLevel = round(float(check_output(["xbacklight"])))

print("%(backlightLevel)s%%" % locals())
