#!/usr/bin/env python

from os import environ
from http.client import HTTPSConnection
from base64 import b64encode
from json import loads
from time import time, sleep
from math import floor
from subprocess import call

token = environ["TOGGL_TOKEN"]

auth_string = "%(token)s:api_token" % locals()
auth = b64encode(auth_string.encode()).decode("ascii")
headers = { "Authorization" : "Basic %s" %  auth }

try:
    connect = HTTPSConnection("www.toggl.com")
    connect.request("GET", "/api/v8/time_entries/current", headers=headers)

    res = connect.getresponse()
    response = res.read()

    connect.close()

    parsed_response = loads(response)
    data = parsed_response["data"]
except Exception:
    print("error")
    exit(33)

if data is None:
    print("[]")

    sleep(1)
    exit()

description = ""
if "description" in data.keys():
    description = data["description"] + " "

duration_raw = data["duration"]

duration = int(time()) + duration_raw

minutes, seconds = divmod(duration, 60)
hours, minutes = divmod(minutes, 60)

time = "%d:%02d:%02d" % (hours, minutes, seconds)

print("%(description)s[%(time)s]" % locals())

sleep(1)
