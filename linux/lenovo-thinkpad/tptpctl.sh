#!/bin/bash

# Enable/disable TouchPad for Lenovo laptops

id=$(xinput list | grep -i TouchPad | sed -E 's/.+id=([0-9]+).+/\1/')

if [ "$id" == "" ]; then
	echo "Could not find touchpad!"
	exit 1
fi

case "$1" in
	enable)  xinput set-prop "$id" "Device Enabled" 1 ;;
	disable) xinput set-prop "$id" "Device Enabled" 0 ;;
	*)       echo "usage: $0 (enable | disable)" ;;
esac

