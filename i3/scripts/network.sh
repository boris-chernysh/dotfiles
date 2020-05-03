#!/bin/bash

SELF_DIR=$( dirname "${BASH_SOURCE[0]}" )

if nmcli -t -f TYPE connection show --active | grep wireless > /dev/null
then
	SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep "^*" | cut -d ":" -f2)

	OUTPUT=$($SELF_DIR/pangoBar.py --min-treshold=20 $SIGNAL)
fi

if nmcli -t -f TYPE connection show --active  | grep vpn > /dev/null
then
	OUTPUT="$OUTPUT:🔒"
fi

echo $OUTPUT