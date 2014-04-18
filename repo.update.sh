#!/bin/bash

str="-type d -iname backup -prune -or -type d -iname backup -prune"

#Check and update svn
for d in `find $str -or -iname .svn -print`
do
    dir=$(dirname $d)
    #echo $dir

    pushd $dir || exit 10
    svn update || exit 12
    svn status || exit 14
    popd > /dev/null
    echo
done

#Then check git dirs
for d in `find $str -or -iname .git -print`
do
    dir=$(dirname $d)
    #echo $dir

    pushd $dir        || exit 20
    git remote update || exit 22
    git status -s     || exit 24
    popd > /dev/null
    echo
done

echo ""
echo "Done..."
exit 0
