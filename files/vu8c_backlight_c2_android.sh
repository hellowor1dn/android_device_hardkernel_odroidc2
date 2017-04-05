#!/bin/sh

path="/sys/class/gpio"

echo 214 > $path/export

echo out > $path/gpio214/direction
echo 0 > $path/gpio214/value

chown system:system $path/gpio214/value

cur_stat="On"

while [ 1 ]; do

    sleep 1

    screen_info=`dumpsys power | grep "Display Power"`

    if [[ $screen_info == *"OFF"* && $cur_stat == "On" ]]; then
        echo "monitor goes to Off"
        # backlight off first
        echo 1 > $path/gpio214/value
        cur_stat="Off"
    elif [[ $screen_info == *"ON"* && $cur_stat == "Off" ]]; then
        echo "monitor turns back On"
        # backlight on later
        echo 0 > $path/gpio214/value
        cur_stat="On"
    fi
done