#!/bin/bash

dox=Doxyfile 

if [ ! -f $dox ]
then
    echo "No Doxyfile in this dir $dox"
    exit 1
fi

# WARN_LOGFILE           = doxygen.warn
if [ "$(grep -e ^WARN_LOGFILE $dox | grep doxygen.warn | wc -l)" = "1" ]
then
    echo "WARN_LOGFILE: ok"
else
    echo "WARN_LOGFILE: fail"
    exit 2
fi

# OUTPUT_DIRECTORY       = doxygen/
if [ "$(grep -e ^OUTPUT_DIRECTORY $dox | grep doxygen | wc -l)" = "1" ]
then
    echo "OUTPUT_DIRECTORY: ok"
else
    echo "OUTPUT_DIRECTORY: fail"
    exit 2
fi

mkdir -p doxygen || exit 3

doxygen || exit 10

echo "Done..."
exit 0
