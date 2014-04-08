#!/bin/bash

# Example use 
# ping_search.sh 192.168.3 2>/dev/null 
# ping_search.sh 192.168.3 2>/dev/null | grep "Found" | awk '{print "finger "$3}'

# ping_search.sh 192.168.2 2>/dev/null 
# ping_search.sh 192.168.0 2>/dev/null | grep Found | sort



echo "Ping all $1"

for ip in {1..255}
do
    ip_arg=$1
    ip_number=$1"."$ip
    #echo $ip_number
    ping -q -c3 $ip_number 2>/dev/null |\
        egrep "[0_9]{1,2}% packet loss" | grep -v "100%" |\
        wc -l | awk '{if ($1>0) print "Found one: '$ip_arg'.'`printf "%03d" $ip`'";}' &
done

echo "Wait for jobs..."
wait

echo "done..."

#ping -q -c1 192.168.3.212 | egrep "[0_9]{1,2}% packet loss" | grep -v "100%" | wc -l 
#ping -q -c1 192.168.3.211 | egrep "[0_9]{1,2}% packet loss" | grep -v "100%" | wc -l | awk '{if ($1>0) print "hello";}'

