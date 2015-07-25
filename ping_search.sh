#!/bin/bash

# Example use
# ping_search.sh 192.168.3 2>/dev/null
# ping_search.sh 192.168.3 2>/dev/null | grep "Found" | awk '{print "finger "$3}'

# ping_search.sh 192.168.2 2>/dev/null
# ping_search.sh 192.168.0 2>/dev/null | grep Found | sort

ip_arg=$1
do_arp=$2

echo "Ping all $1"

for ip in {1..255}
do
    ip_number=$ip_arg"."$ip
    #echo $ip_number
    ping -q -c3 $ip_number 2>/dev/null |\
        egrep "[0_9]{1,2}% packet loss" | grep -v "100%" |\
        wc -l | awk '{if ($1>0) print "Found one: '$ip_arg'.'`printf "%03d" $ip`'";}' &
done

echo "Wait for jobs..."
echo
wait

if [ ! -z $do_arp ]
then
    # Since we just ping:ed everyting on this subnet, the arp tables is now updated.
    # print all ip:s and names found in the arp table (sorted by ip)...
    arp -a |\
        grep -v '?*incomplete' |\
       awk '{ t = $1; $1 = $2"\t"; $2 = t; print; }' |\
       tr -d '(' | tr -d ')' |\
       sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4
    echo

    # For more info on the last sort...
    # https://www.madboa.com/geek/sort-addr/
fi

echo "done..."

#ping -q -c1 192.168.3.212 | egrep "[0_9]{1,2}% packet loss" | grep -v "100%" | wc -l
#ping -q -c1 192.168.3.211 | egrep "[0_9]{1,2}% packet loss" | grep -v "100%" | wc -l | awk '{if ($1>0) print "hello";}'

