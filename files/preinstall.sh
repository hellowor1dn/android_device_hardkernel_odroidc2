#!/bin/sh

pkgs=`ls /cache/*.apk`

for apk in $pkgs; do
        echo "Installing package: " $apk
#        pm install $apk
        rm -f $apk
done

env=`fw_printenv`
for x in $env;
    do
    case $x in
        ddrclk=*) setprop ro.ddr.clock $x; break
    esac
done
