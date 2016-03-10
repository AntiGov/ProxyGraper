#!/bin/bash
#coded by G66K
#freenode . ##spoonfed
#this script was design for class dnsreverse its good for automate classes
class=$1
file=$2
if [ $# -ne 2 ];then
 echo "Usage $0 192.168.1.1-192.168.254.154 result.txt"
 exit 1
els
 
fi

start=$( echo $class | cut -d "-" -f1)
end=$(   echo $class | cut -d "-" -f2)

mainclass=$(   echo $start |  cut -d "." -f1)
class1start=$( echo $start | cut -d "." -f2)
class2start=$( echo $start | cut -d "." -f3)
class3start=$( echo $start | cut -d "." -f4)

class1end=$(echo $end| cut -d "." -f2)
class2end=$(echo $end| cut -d "." -f3)
class3end=$(echo $end| cut -d "." -f4)

for a in $(seq $class1start $class1end);do
for b in $(seq $class2start $class2end);do
for c in $(seq $class3start $class3end);do
host $mainclass.$a.$b.$c|grep -v "not found"| awk '{print $5}' | sed 's/.$//'
host $mainclass.$a.$b.$c|grep -v "not found"| awk '{print $5}' | sed 's/.$//' >> "$file"
done
done
done
