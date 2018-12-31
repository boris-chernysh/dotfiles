#!/bin/bash

UPDATES=$(pamac checkupdates | head -1)

if [ "$UPDATES" = "Your system is up-to-date." ] || [ -z "$UPDATES" ]
then
	echo 👌
else
	echo $(awk '{print $1;}' <<< "$UPDATES")
	exit 33
fi
