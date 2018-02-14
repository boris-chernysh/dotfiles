#!/usr/bin/env python

from math import (floor)

file = open("/proc/meminfo", "r")

def getNumber(string):
    return [int(char) for char in string.split() if char.isdigit()][0]

memTotal = getNumber(file.readline())
file.readline()
memAvail = getNumber(file.readline())
memUsage = memTotal - memAvail

usagePercent = floor((memUsage / memTotal) * 100)

color = ""

if usagePercent > 80:
    color = "#FF0000"

memUsageInGb = round(memUsage / 1024 / 1024, 2)
pangoColor = (" color=\"%(color)s\"" % locals() if len(color) else "")

print("<span%(pangoColor)s>%(memUsageInGb)sG</span>" % locals())
