#!/bin/bash

if [ "$BLOCK_BUTTON" = 3 ]
then
	kitty --hold pamac update
fi

UPDATES=$(pamac checkupdates | head -1)

if [ "$UPDATES" = "Your system is up-to-date." ] || [ -z "$UPDATES" ]
then
	echo 👌
else
	UPDATES_COUNT=$(awk '{print $1;}' <<< "$UPDATES")
	echo $UPDATES_COUNT
fi
