#!/bin/bash

gcovr=~/gcovr/scripts/gcovr
JOBS="-j$((`getconf _NPROCESSORS_ONLN` + 1))"

if [ ! -d test/ ]
then
    echo "PWD $PWD"
    ls -lh
    echo "No dir called test"
    exit 50
fi

base=$PWD
echo $base

for test in $(find -name *.pro | grep -e ^./test/)
do
    echo "BEGIN: "$test
    dir=$(dirname $test)
    name=$(basename $test .pro)
    pushd $dir || exit 60
    echo $name

    make distclean > /dev/null 2>&1
    qmake || exit 61

    # Since Jenkins looks in the base dir, but we compile in the subdirs
    gccOut=tmp_gcc_out.log
    make $JOBS > $gccOut 2>&1 
    if [ ! $? = 0 ]
    then
        cat $gccOut
        exit 62
    fi

    src=$(grep SOURCES *.pro | sed s/SOURCES//g | tr -d '+' | tr -d '=' | tr -d '\n' | tr -s ' ')
    echo "src list: $src"
    for s in $src
    do
        #But will this work for files not in this test dir?
        to=$(echo $dir'/'$s | sed 's/^.\///g' | sed 's/\//\\\//g')
        echo "PATH: $s -> $to"
        sed -i 's/^'$s'/'$to'/g' $gccOut #|| exit 64
    done

    cat $gccOut
    rm $gccOut

    if [ ! -f $name ]
    then
        echo "Build error:"
        echo $test
        exit 63
    fi

    ./$name -xunitxml -o $base/xUnit_report_$name.xml || exit 64
    valgrind --xml=yes --xml-file=$base/valgrind_report_$name.xml --leak-check=full ./$name || exit 65

    make distclean || exit 66

    if [ -f $gcovr ]
    then
        qmake LIBS+="-lgcov" \
            QMAKE_CFLAGS+="-O0 -g" \
            QMAKE_CXXFLAGS+="-O0 -g -fprofile-arcs -ftest-coverage" \
            QMAKE_LDFLAGS+="-g -Wall -fprofile-arcs" || exit 70
        #We have the gcc warnings above, so dont show them again...
        make $JOBS > /dev/null 2>&1 || exit 71

        ./$name || exit 72
        $gcovr --exclude=.*/test/.* --exclude=.*/include/qt.* --exclude=/usr/include/.* \
            --xml --output=$base/gcov_report_$name.xml || exit 73
        make distclean || exit 74
    fi

    popd
    echo "END: "$test
    echo ""
done

exit 0
