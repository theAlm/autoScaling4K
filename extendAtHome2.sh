#!/bin/sh
# extend internal HiDPI-display on eDP* to the HiDPI external display DP*, 
# which is placed to the left hand side of the internal display
# see also https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319


# from running 
# $ xrandr
# we know the resolutions e.g.:
# internal monitor: eDP1 connected 2560x1440+0+0 (normal left inverted right x axis y axis) 310mm x 170mm
# my Philips monitor: DP2-1 connected primary 1920x1080+2560+0 (normal left inverted right x axis y axis) 530mm x 300mm

# get the resolutions of the external and internal display
EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`

# get the absolute displays images widths and heights in pixels (EXTernal and INTernal Monitor)
EXT_W=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
EXT_H=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`

INT_W=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
INT_H=`xrandr | sed 's/^'"${INT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`

# calculate the resolution width and height of the internal monitor after scaling
# that is double of the internals display hight and width
S_INT_W=`echo $(( $INT_W*2 ))  | sed 's/^-//'`
off_w=`echo $(( ($INT_W-$EXT_W)/2 )) | sed 's/^-//'` 
s_int_h=`echo $( $INT_H*2)  | sed 's/^-//'`

# set the output resolution for the monitors



# on internal eDP1 monitor
xrandr --output "${INT}" --auto --pos 0x0 --scale 1x1 
# on external DP2-1 monitor
xrandr --output "${EXT}" --auto --pos ${off_w}x0 --scale 1x1



# internal eDP1 monitor first and exteranl eDP2 minitor second
xrandr --output "${INT}" --auto --pos ${off_w}x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0 
