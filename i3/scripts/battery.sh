#!/bin/bash

SELF_DIR=$( dirname "${BASH_SOURCE[0]}" )
CHARGE=$(acpi -b | grep -oPh "[0-9]+(?=%)")
OUTPUT=$($SELF_DIR/pangoBar.py --min-treshold=20 $CHARGE)

if acpi -a | grep -oPh "on-line" > /dev/null;
then
	OUTPUT="$OUTPUT:⚡"
fi

echo $OUTPUT
