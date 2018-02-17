#!/usr/bin/env python

from math import floor
from sys import exit

def get_number(string):
    return [int(char) for char in string.split() if char.isdigit()][0]

try:
    file = open("/proc/meminfo", "r")

    mem_total = get_number(file.readline())
    file.readline()
    mem_avail = get_number(file.readline())
except Exception:
    print('error')
    exit(33)

mem_usage = mem_total - mem_avail

usage_percent = floor((mem_usage / mem_total) * 100)

color = ""

if usage_percent > 80:
    color = "#FF0000"

mem_usage_in_gb = round(mem_usage / 1024 / 1024, 2)
pango_color = (" color=\"%(color)s\"" % locals() if len(color) else "")

print("<span%(pango_color)s>%(mem_usage_in_gb)sG</span>" % locals())
