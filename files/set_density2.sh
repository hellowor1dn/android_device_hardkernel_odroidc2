#!/bin/sh

SIZE=`wm size`

ORIENTATION=`getprop | grep persist.demo.hdmirotation`
echo $ORIENTATION
if [ "$ORIENTATION" == "[persist.demo.hdmirotation]: [landscape]" ]; then
	retval=1
else
	retval=0
fi

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
elif [ "$SIZE" == "Physical size: 2560x1080" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
	break
elif [ "$SIZE" == "Physical size: 2560x1440" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
	break
elif [ "$SIZE" == "Physical size: 2560x1600" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
	break
elif [ "$SIZE" == "Physical size: 3440x1440" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
	break
fi
