#!/bin/bash

# sudo apt-get install ckermit

date=`date +"%F_%H%M%S"`

if [ "$1" == "" ]; then
  echo "Error no args: "$0
  exit 10
fi

dev=$1
if [ -e $dev ];then
echo "OK dev="$dev
else
  echo "Cant find: "$dev
  exit 11
fi

mkdir -p ~/kermit.log || exit 12
cd ~/kermit.log       || exit 13

log=kermit.$date.log
config=~/.kermit.config

echo "Break with ctrl+\\c"
echo ""
echo "LOG SESSION "$log > $config
echo "SET LINE    "$dev >>$config
cat >> $config  << EOF
SET SPEED  115200
SET CARRIER-WATCH OFF
SET PARITY none
CONNECT
EOF

kermit $config
