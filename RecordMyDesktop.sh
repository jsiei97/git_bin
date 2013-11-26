#!/bin/bash

# sudo apt-get install recordmydesktop 

info=xwininfo.log

echo "Klick in a window to record it."
xwininfo > $info
xid=`grep "Window id" $info | awk '{print $4}'`

recordmydesktop --windowid=$xid --fps=5 --freq=22500 -o out_$(date +"%F_%H%M%S").ogv
#recordmydesktop --windowid=$xid --on-the-fly-encoding --fps=5 --freq=22500 -o out_$(date +"%F_%H%M%S").ogv
#recordmydesktop --windowid=$xid --fps=10 --freq=22500 

