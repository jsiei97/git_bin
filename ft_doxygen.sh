#!/bin/bash

dox=Doxyfile 

if [ ! -f $dox ]
then
    echo "No Doxyfile in this dir $dox"
    exit 1
fi

if [ "$(grep -e ^WARN_LOGFILE $dox | grep doxygen.warn | wc -l)" = "1" ]
then
    echo "WARN_LOGFILE: ok"
else
    echo "WARN_LOGFILE: fail"
    exit 2
fi

doxygen || exit 3

echo "Done..."
exit 0
