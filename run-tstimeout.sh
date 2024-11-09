#!/usr/bin/env bash
# Run program to turn off RPi backlight after a period of time,
# turn on when the touchscreen is touched.
# Best to run this script from /etc/rc.local to start at boot.

declare -a devs

if [ ! \( \( "${USER}" = "root" \) -o \( -n "${EUID}" -a ${EUID} = 0 \) \) ]
then
        echo "root privs required. re-run with sudo."
        exit 1
fi

delay=${1}
delay=${delay//[^0-9]/}

timeout_period=${delay:-30} # seconds

# Find the device the touchscreen uses.  This can change depending on
# other input devices (keyboard, mouse) are connected at boot time.
# This simpler method lets all inputs trigger the backlight restoral
for line in $(lsinput); do
        if [[ $line != *"FT5406"* ]] ; then
            if [ -n "$line" -a -z "${line//\/dev\/input\/*/}" ]; then
                dev="${line//*input\//}"
		devs+=($dev)
            fi
        fi

done

bldirs=$(find -L /sys/class/backlight/ -maxdepth 1 -type d -iwholename '/sys/class/backlight/[0-9]*' | sed 's|/sys/class/backlight/||g;')

# Use nice as it sucks up CPU.
# Timeout is in /usr/local/bin so as not to conflict with /bin/timeout
# Usage: timeout <timeout_sec> <backlight> <device> [<device>...]
#    Backlights are in /sys/class/backlight/<backlight>.
#    Use lsinput to see input devices.
#    Device to use is shown as /dev/input/<device>

for bl in ${bldirs}
do
	nice -n 19 /usr/local/bin/tstimeout $timeout_period $bl ${devs[@]} &
done
