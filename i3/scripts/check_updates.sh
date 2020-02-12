#!/bin/bash

if [ "$BLOCK_BUTTON" = 3 ]
then
	kitty --hold pamac update
fi

if which pamac &>/dev/null
then
	UPDATES=$(pamac checkupdates | head -1)
elif which dnf &>/dev/null
then
	UPDATES=$(dnf check-update | grep 'updates' -c)
fi

if [ "$UPDATES" = "Your system is up-to-date." ] || [ -z "$UPDATES" ] || [ "$UPDATES" = "0" ]
then
	echo 👌
else
	UPDATES_COUNT=$(awk '{print $1;}' <<< "$UPDATES")
	echo $UPDATES_COUNT
fi
