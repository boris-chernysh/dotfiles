#!/bin/bash

UPDATES=$(pamac checkupdates | head -1)

if [ "$UPDATES" = "Your system is up-to-date." ] || [ -z "$UPDATES" ]
then
	echo 👌
else
	UPDATES_COUNT=$(awk '{print $1;}' <<< "$UPDATES")
	echo $UPDATES_COUNT
	notify-send "$UPDATES_COUNT packages awaiting update"
fi
