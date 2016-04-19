#!/bin/sh

while true
do

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
	if [ `echo $RESULT | grep -c "No such file or directory"`-gt 0 ]; then
		rmmod rtc_pcf8563
		break
	fi

	DATE=`date`
	echo $DATE
	if [ `echo $DATE | grep -c " 1970"` -gt 0 ]; then
		hwclock -s
		echo "Set system time from hardware clock"
	fi

	RESULT=`getprop | grep dhcp.wlan0.result`
	echo $RESULT
	if [ `echo $RESULT | grep -c "ok"` -gt 0 ]; then
		echo "connected wifi"
		echo "Set hardware clock from system time"
		hwclock -w
	else
		RESULT=`getprop | grep dhcp.eth0.result`
		echo $RESULT
		if [ `echo $RESULT | grep -c "ok"` -gt 0 ]; then
			echo "connected ethernet"
			echo "Set hardware clock from system time"
			hwclock -w
		fi
	fi

	sleep 600

done
