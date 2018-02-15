#!/bin/bash

case $(xkblayout-state print "%s") in
	"us" ) echo 🇺🇸;;
	"ru" ) echo 🇷🇺;;
esac
