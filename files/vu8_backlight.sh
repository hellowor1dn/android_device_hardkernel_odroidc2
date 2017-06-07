#!/bin/sh

echo 214 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio214/direction
