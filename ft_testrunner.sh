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
    echo $test
    dir=$(dirname $test)
    name=$(basename $test .pro)
    pushd $dir || exit 60
    echo $name
    qmake || exit 61
    make $JOBS || exit 62
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
            QMAKE_CXXFLAGS+="-g -Wall -fprofile-arcs -ftest-coverage" \
            QMAKE_LDFLAGS+="-g -Wall -fprofile-arcs" || exit 70
        make $JOBS || exit 71

        $gcovr --exclude=.*/test/.* --exclude=.*/include/qt.* \
            --xml --output=$base/gcov_report_$name.xml || exit 73
        make distclean || exit 74
    fi

    popd
done

exit 0
