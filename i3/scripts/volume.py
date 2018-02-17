#!/usr/bin/env python

import re

from time import sleep
from subprocess import Popen, PIPE

def get_type_and_loud(info):
    name = re.search("^[ a-zA-Z]*(?=:)", info).group(0)
    short_name = "".join(re.findall("[A-Z]", name))
    loud = re.search("[0-9]{1,3}%", info).group(0)

    return (short_name, loud)

try:
    process = Popen(["amixer", "get", "Master"], stdout=PIPE, stderr=PIPE)
    output, err = process.communicate()
    speakers_raw_info = re.findall("[a-zA-Z ]+:.*[[0-9]{1,2}%].*", output.decode("utf-8"))
except Exception:
    print('error')
    exit(33)

speakers_info = [get_type_and_loud(raw_info) for raw_info in speakers_raw_info]
if all(speakers_info[0][1] == info[1] for info in speakers_info):
    print(speakers_info[0][1])
    exit()

print(",".join([":".join(info) for info in speakers_info]))
