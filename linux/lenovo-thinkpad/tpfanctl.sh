#!/bin/bash

# Fan control for Lenovo Thinkpads
# Prerequisite: echo 'options thinkpad_acpi fan_control=1' > /etc/modprobe.d/tp-fan.conf

function usage() {
	echo "Usage: $(basename $0) <mode>"
	echo "
 Modes:
 ------
 0          : fan off
 2          : low speed
 4          : medium speed
 7          : maximum speed
 auto       : automatic (default)
 disengaged : disengaged
"
}

if [ "$1" == "" ]; then
	usage
	exit 0
fi

if [ $(id -u) -ne 0 ]; then
	echo 'Error: become root first!'
	exit 1
fi

lsmod | grep thinkpad_acpi &> /dev/null
if [ $? -ne 0 ]; then
	echo 'Error: module `thinkpad_acpi` not loaded!'
	exit 1
fi

if [ ! -f /sys/module/thinkpad_acpi/parameters/fan_control ]; then
	echo 'Error: fan control not possible!'
	exit 1
fi

if [ $(cat /sys/module/thinkpad_acpi/parameters/fan_control) == 'N' ]; then
	echo 'Error: fan control disabled!'
	echo "Fix:   echo 'options thinkpad_acpi fan_control=1' > /etc/modprobe.d/tp-fan.conf"
	echo "       modprobe -r thinkpad_acpi && modprobe thinkpad_acpi"
	exit 1
fi

if [ ! -w /proc/acpi/ibm/fan ]; then
	echo 'Error: `/proc/acpi/ibm/fan` does not exsist or is not writeable!'
	exit 1
fi

case "$1" in
	0) echo -e "\e[33mWARNING\e[39m: fan is off!" ; echo 'level 0' > /proc/acpi/ibm/fan ; exit 0 ;;
	2) echo 'level 2' > /proc/acpi/ibm/fan ; exit 0 ;;
	4) echo 'level 4' > /proc/acpi/ibm/fan ; exit 0 ;;
	7) echo 'level 7' > /proc/acpi/ibm/fan ; exit 0 ;;
	auto) echo 'level auto' > /proc/acpi/ibm/fan ; exit 0 ;;
	disengaged) echo 'level disengaged' > /proc/acpi/ibm/fan ; exit 0 ;;
	*) echo "Error: unknown mode!" ; usage ; exit 1 ;;
esac
