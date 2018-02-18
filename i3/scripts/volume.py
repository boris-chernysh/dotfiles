#!/usr/bin/env python

from time import sleep
from subprocess import Popen, PIPE
from re import search, findall, match

def get_name(info):
    name = search("^[ a-zA-Z]*(?=:)", info).group(0)
    return "".join(findall("[A-Z]", name))

def get_loud(info):
    return search("[0-9]{1,3}%", info).group(0)

def check_muted(info):
    return "[off]" in info

try:
    process = Popen(["amixer", "get", "Master"], stdout=PIPE, stderr=PIPE)
    output, err = process.communicate()
    speakers_raw_info = findall("[a-zA-Z ]+:.*[[0-9]{1,2}%].*", output.decode("utf-8"))
except Exception:
    print('error')
    exit(33)

speakers_info = [
    (get_name(raw_info), get_loud(raw_info), check_muted(raw_info))
    for raw_info
    in speakers_raw_info
]

if all(speakers_info[0][2] for info in speakers_info):
    print("MUTE")
    exit()

if all(speakers_info[0][1] == info[1] for info in speakers_info):
    print(speakers_info[0][1])
    exit()

print(",".join([":".join((info[0], info[1])) for info in speakers_info]))
