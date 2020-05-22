#!/bin/sh
# extends non-HiDPI external display on DP* above HiDPI internal display eDP*

# the bug is documentet here https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319


# read in the signals using xrandr

# EXT is the external monitor  and INT the internal display
EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`

# get postion and resolution of the displays
ext_w=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
int_w=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
off_w=`echo $(( ($int_w-$ext_w)/2 )) | sed 's/^-//'`

# the internal monitor (first) is placed below the external monitor
# The global scaling factors 1 and 2 should prevent the alializing, because they are less then the Nyquist-frequency for my 4k-laptop-display 
# (2.560 x 1.440 px, IPS-Panel, 14 inches).
# (see https://en.wikipedia.org/wiki/Nyquist_frequency)

xrandr --output "${INT}" --auto --pos ${off_w}x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0 
