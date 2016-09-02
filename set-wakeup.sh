#!/bin/bash
# clear rtc wakeup timer
echo 0 > /sys/class/rtc/rtc0/wakealarm
# set rtc wakeup timer to 23:55 tonight
echo $(date -d "23:55" +%s) > /sys/class/rtc/rtc0/wakealarm
