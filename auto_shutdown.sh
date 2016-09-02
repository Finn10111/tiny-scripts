#!/bin/bash

# This is a tiny script which shut downs the computer if none of the given
# hosts is online anymore. Customize the HOSTS array to fit your needs.

HOSTS=( 
'example'
'foobar'
)

OFFLINE_HOSTS=0

for HOST in ${HOSTS[@]}
do
    ping -c 3 $HOST > /dev/null 2>&1
    EXITSTATUS=$?
    if [[ $EXITSTATUS -eq 1 ]]
    then
        OFFLINE_HOSTS=$((OFFLINE_HOSTS + 1))
    fi 
done

if [[ $OFFLINE_HOSTS -eq ${#HOSTS[@]} ]]
then
    # check if a RAID array could exist
    if [[ -f "/proc/mdstat" ]]
    then
        # shutdown but check if raid is clean before shutdown
        NONOK_RAID_COUNT = $(grep -c "\[.*_.*\]|recovery" /proc/mdstat)
        if [[ $NONOK_RAID_COUNT -eq 0 ]]
        then
            # shutdown, RAID is clean
            /sbin/shutdown -h now
        fi
    else
        # shutdown, there is no RAID
        /sbin/shutdown -h now
    fi
fi
