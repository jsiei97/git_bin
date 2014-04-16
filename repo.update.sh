#!/bin/bash

#todo: add a better ignore list

#Check and update svn
for d in `find -type d -iname .svn | grep -v backup`
do
    dir=$(dirname $d)
    echo $dir

    pushd $dir || exit 10
    svn update || exit 12
    svn status || exit 14
    popd
    echo
done

#Then check git dirs
for d in `find -type d -iname .git | grep -v backup`
do
    dir=$(dirname $d)
    echo $dir

    pushd $dir        || exit 20
    git remote update || exit 22
    git status -s     || 24
    popd
    echo
done
