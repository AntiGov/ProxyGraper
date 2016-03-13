#!/bin/bash
#Author: G66K

usage()
{
cat << EOF
usage: $0 options

Automate Reverse dns

OPTIONS:
   -h      Show this message
   -c      Class A.B.C e.g: 66.196.113.0-66.196.113.10
   -f      file for result
   -v      Verbose
EOF
}

CLASS=
FILE=
VERBOSE=
while getopts “h:c:f:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
       
         c)
             CLASS=$OPTARG
             ;;
         f)
             FILE=$OPTARG
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if  [[ -z $CLASS ]] || [[ -z $FILE ]]
then
     usage
     exit 1
fi


start=$( echo $CLASS | cut -d "-" -f1)
end=$(   echo $CLASS | cut -d "-" -f2)

mainclass=$(   echo $start | cut -d "." -f1)
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

host $mainclass.$a.$b.$c|grep -v "not found"| awk '{print $5}' | sed 's/.$//' >> "$FILE"
done
done
done
if [[ -f $FILE ]]
then
echo "Result saved in $FILE";
fi
