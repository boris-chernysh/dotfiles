#!/bin/bash

SCREENS_COUNT=$(xrandr | grep ' connected' -c)
DIR=$(dirname "${BASH_SOURCE[0]}")

echo $DIR > /tmp/screenslog

case "$SCREENS_COUNT" in
	3) bash "$DIR/screenlayout/3.sh";;
	2) bash "$DIR/screenlayout/2.sh";;
	*) bash "$DIR/screenlayout/1.sh";;
esac
