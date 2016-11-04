#!/bin/sh

if [ -e "/dev/rtc0" ]; then
	echo "found /dev/rtc0"
else
	echo "not found /dev/rtc0"
	echo "insmod modules for rtc"
	insmod /system/lib/modules/aml_i2c.ko
	insmod /system/lib/modules/rtc-pcf8563.ko
	sleep 1
fi

RESULT=`hwclock -r`
echo $RESULT
if [ `echo $RESULT | grep -c "No such file or directory"` -gt 0 ]; then
	rmmod rtc_pcf8563
elif [ "$RESULT" == "" ]; then
	rmmod rtc_pcf8563
fi

hwclock -s
