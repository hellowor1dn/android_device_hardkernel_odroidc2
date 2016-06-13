#!/bin/sh

echo 126 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio126/direction
echo 0 > /sys/class/gpio/gpio126/value
sleep 1
echo 1 > /sys/class/gpio/gpio126/value
echo 126 > /sys/class/gpio/unexport
