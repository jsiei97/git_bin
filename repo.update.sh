#!/bin/bash

# Ignore dirs with names like:
ignore="backup old mod"

# Fix the "find string"
for ig in $ignore
do
    str=$str" -type d -iname $ig -prune -or"
done

# Check git dirs
for d in `find $str -iname .git -print`
do
    dir=$(dirname $d)
    #echo $dir

    pushd $dir        || exit 20
    git remote update || exit 22
    #git pull         || exit 23
    git status -s     || exit 24
    popd > /dev/null
    echo
done

# Check and update subversion dirs
for d in `find $str -iname .svn -print`
do
    dir=$(dirname $d)
    #echo $dir

    pushd $dir || exit 10
    svn update || exit 12
    svn status || exit 14
    popd > /dev/null
    echo
done

echo ""
echo "Done..."
exit 0
