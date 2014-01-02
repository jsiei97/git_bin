#!/bin/bash

for target in $* 
do
    base=$(basename $target)
    echo $target $base
    if [ ! -e $base ]
    then
        echo "linking "$base
        ln -s $target $base
    fi
done
