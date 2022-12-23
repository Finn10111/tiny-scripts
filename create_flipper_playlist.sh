#!/bin/bash

DIR="/run/media/finn/FLIPPER SD/"

find "$DIR/subghz/Doorbells" -type f -iname '*sub' | sed "s~$DIR~sub: /ext~g" > "${DIR}subghz/playlist/doorbells.txt"
find "$DIR/subghz/LED" -type f -iname '*sub' | sed "s~$DIR~sub: /ext~g" > "${DIR}subghz/playlist/leds.txt"
find "$DIR/subghz/Remote_Outlet_Switches" -type f -iname '*sub' | sed "s~$DIR~sub: /ext~g" > "${DIR}subghz/playlist/remote_outlet_switches.txt"
find "$DIR/subghz/Misc" -type f -iname '*sub' | sed "s~$DIR~sub: /ext~g" > "${DIR}subghz/playlist/misc.txt"
