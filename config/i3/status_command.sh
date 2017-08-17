#!/bin/bash

i3status | while :
do
    read line
    temperature=`sensors | awk 'NR==3' | awk '{ print substr($0, 18, 6) }'`
    clock=`date`
    cpu=`grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}'`
    current_window=`xdotool getactivewindow getwindowname`
    echo "$current_window | $cpu | $temperature | $clock" || exit 1
done
