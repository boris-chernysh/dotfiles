#!/bin/bash

TOTAL=$(cat /proc/meminfo | grep MemTotal | grep -oPh "[0-9]*")
AVAILABLE=$(cat /proc/meminfo | grep MemAvailable | grep -oPh "[0-9]*")

$( dirname "${BASH_SOURCE[0]}" )/pangoBar.py --max-treshold=$(echo $TOTAL *.8 | bc) --max-value=$TOTAL --steps-count=$(( TOTAL / 1024 / 1024 )) $(( TOTAL - AVAILABLE ))
