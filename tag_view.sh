#!/bin/bash

# sudo apt-get install exuberant-ctags cscope

#This script will create
# - cscope.files
# - cscope.out
# - tags

#
# http://aplawrence.com/Unix/getopts.html
#
args=`getopt c $*`
if test $? != 0
then
    echo 'Usage: -c (cleanup) -d dir'
    exit 1
fi
set -- $args
for i
do
    case "$i" in
        -c) shift;echo "cleanup ... ";rm tags cscope.*; exit 0;
    esac
done



start=`date +"%s"`

cwd=`pwd`
echo "Let's tag this dir: $cwd"

echo "Let's do a file list (cscope.files)"

#.c .h .s .cpp .cxx .cc .java
find -H \
    -type f -iname '*.[chs]' -or \
    -type f -iname '*.cpp' -or \
    -type f -iname '*.cxx' -or \
    -type f -iname '*.cc' -or \
    -type f -iname '*.java' \
    | grep -v \.svn > cscope.files

echo "Let's run ctags on this list"
ctags -R --c-kinds=+p --fields=+S -L cscope.files

echo "Let's add some more files for just cscope"

find -H \
    -type f -iname 'Makefile' -or \
    -type f -iname 'Makefile.*' -or \
    -type f -iname '*.make' -or \
    -type f -iname '*.mk' -or \
    -type f -iname '*.mak' -or \
    -type f -iname '*.pro' -or \
    -type f -iname '*.pri' -or \
    -type f -iname '*.cfg' -or \
    -type f -iname '*.conf' -or \
    -type f -iname '*.xml' -or \
    -type f -iname '*.xsd' -or \
    -type f -iname '*.sh' -or \
    -type f -iname '*.bsh' -or \
    -type f -iname '*.pl' \
    | grep -v \.svn  >> cscope.files

echo "and cscope..."
cscope -b

stop=`date +"%s"`
declare -i used
used=$stop-$start
#echo "Time: $start $stop "
echo "Time used: $used s"


