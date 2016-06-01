#!/bin/sh

ORIENTATION=`getprop persist.demo.hdmirotation`
if [ "$ORIENTATION" == "landscape" ]; then
	retval=1
else
	retval=0
fi

W=`getprop const.window.w`
H=`getprop const.window.h`

if [ "$W" == "640" ] && [ "$H" == "480" ]; then
	wm density 120
elif [ "$W" == "800" ] && [ "$H" == "480" ]; then
	if [ "$retval" == 1 ]; then
		wm density 120
	else
		wm density 160
	fi
elif [ "$W" == "800" ] && [ "$H" == "600" ]; then
	wm density 160
elif [ "$W" == "1024" ] && [ "$H" == "600" ]; then
	wm density 160
elif [ "$W" == "1280" ] && [ "$H" == "800" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 180
	fi
elif [ "$W" == "1280" ] && [ "$H" == "1024" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 240
	fi
elif [ "$W" == "720" ] && [ "$H" == "480" ]; then
	wm density 120
elif [ "$W" == "720" ]  && [ "$H" == "576" ]; then
	if [ "$retval" == 1 ]; then
		wm density 120
	else
		wm density 160
	fi
elif [ "$W" == "1280" ] && [ "$H" == "720" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 180
	fi
elif [ "$W" == "1920" ] && [ "$H" == "1080" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
elif [ "$W" == "2560"  ] && [  "$H" == "1080" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
elif [ "$W" == "2560"  ] && [  "$H" == "1440" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
elif [ "$W" == "2560"  ] && [  "$H" == "1600" ]; then
	if [ "$retval" == 1 ]; then
		wm density 160
	else
		wm density 260
	fi
fi
