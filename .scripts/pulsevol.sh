#!/bin/bash

#
# TODO: Fix problems with multiple sinks in awk lines. Make sure $muted only contains one line.
#

# Variables
usage="Usage: $0: [-i increment] [-s sink] {up|down|mute|unmute|toggle|query}" 
increment=5
sink=
maxVolume=65537

# Functions

getPercentage() {
	currentVolume=$(pacmd list-sinks | grep "front-left" | sed 's/[:%]//g' | awk '{ print $5 }' | head -n1 )
}


getMute() {
	muted=$(pacmd list-sinks | grep "muted" | awk '{ print $2 }')
}

stat() {
	getPercentage
	getMute
}

toggle() {
	if [ $muted == "no" ]; then
		mute;
	else
		unmute;
	fi
}

mute() {
	pacmd set-sink-mute $sink 1 > /dev/null
}
 
unmute() {
	pacmd set-sink-mute $sink 0 > /dev/null
}

query() {
	echo "Volume: $currentVolume% Muted: $muted"
}

setVolume() {
if [ $newVolume -gt $maxVolume ]; then
		newVolume=$maxVolume
	elif [ $newVolume -lt 0 ]; then
		newVolume=0
	fi
	if [ $muted == "yes" ]; then
		unmute
	fi
	pacmd set-sink-volume $sink $newVolume > /dev/null
	stat
	query
}

stat

# Main
while getopts i:s: arg
do
	case $arg in
	i)		increment=$OPTARG
			;;
	s)		sink=$OPTARG
			;;
	esac
	shift $(($OPTIND - 1))
done

# Set sink to first availible if not set
if [ -z "$sink" ]; then
  sink=$(pacmd list-sinks | grep index | awk '{ print $3 }')
  if [ -z "$sink" ]; then
    echo "No Sink Availible! Exiting..."
    exit 1
  fi
fi

case $* in
	up)		newVolume=$[$[$maxVolume/100] * $[$currentVolume+$increment]]
			setVolume
			;;
	down)	newVolume=$[$[$maxVolume/100] * $[$currentVolume-$increment]]
			setVolume
			;;
	toggle)	toggle
			;;
	mute)	mute
			;;
	unmute)	unmute
			;;
	query)	query
			;;
	help)	echo $usage
			;;
	*)  echo $usage
			exit 0;
			;;
esac
