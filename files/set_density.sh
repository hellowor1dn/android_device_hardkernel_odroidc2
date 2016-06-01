#!/bin/sh

sleep 5
SIZE="Error type 2"

function get_orientation()
{
	ORIENTATION=`getprop | grep persist.demo.hdmirotation`
	echo $ORIENTATION
	if [ "$ORIENTATION" == "[persist.demo.hdmirotation]: [landscape]" ]; then
		retval=1
	else
		retval=0
	fi
}

while true
do
	case $SIZE in
		Error*)
			echo "wm not ready"
			sleep 1
			SIZE=`wm size`
			if [ "$SIZE" == "" ]; then
				SIZE="Error type 2"
			fi
			get_orientation
		;;
		Physical*)
			if [ "$SIZE" == "Physical size: 640x480" ]; then
				wm density 120
				break
			elif [ "$SIZE" == "Physical size: 800x480" ]; then
				if [ "$retval" == 1 ]; then
					wm density 120
				else
					wm density 160
				fi
				break
			elif [ "$SIZE" == "Physical size: 800x600" ]; then
				wm density 160
				break
			elif [ "$SIZE" == "Physical size: 1024x600" ]; then
				wm density 160
				break
			elif [ "$SIZE" == "Physical size: 1280x800" ]; then
				if [ "$retval" == 1 ]; then
					wm density 160
				else
					wm density 180
				fi
				break
			elif [ "$SIZE" == "Physical size: 1280x1024" ]; then
				if [ "$retval" == 1 ]; then
					wm density 160
				else
					wm density 240
				fi
				break
			elif [ "$SIZE" == "Physical size: 720x480" ]; then
				wm density 120
				break
			elif [ "$SIZE" == "Physical size: 720x576" ]; then
				if [ "$retval" == 1 ]; then
					wm density 120
				else
					wm density 160
				fi
				break;
			elif [ "$SIZE" == "Physical size: 1280x720" ]; then
				if [ "$retval" == 1 ]; then
					wm density 160
				else
					wm density 180
				fi
					break
			elif [ "$SIZE" == "Physical size: 1920x1080" ]; then
				if [ "$retval" == 1 ]; then
					wm density 160
				else
					wm density 260
				fi
				break
			fi
	esac
done
