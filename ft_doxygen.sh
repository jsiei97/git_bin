#!/bin/bash

#
# http://aplawrence.com/Unix/getopts.html
#
args=`getopt cb $*`
if test $? != 0
then
    echo 'Usage: -c (cleanup) -d dir'
    exit 1
fi
set -- $args
for i
do
    case "$i" in
        -c) shift;echo "cleanup ... ";rm -rf doxygen*; exit 0;;
        -b) shift;generatepdf="true";;
    esac
done

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

if [ "$generatepdf" = "true" ]
then
    pdf="doxygen.$(basename $PWD).pdf"
    pushd doxygen/latex || exit 20
    make || exit 21
    cp refman.pdf "../../$pdf" || exit 22
fi

echo "Done..."
exit 0
