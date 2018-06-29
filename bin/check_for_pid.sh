#!/bin/bash

if [ -z "$1" ] ; then 
 echo "supply pid"
 exit 1
fi

pid=$1
while [ 1 ] ; do
 kill -s 0 $pid 2> /dev/null 
 if [ $? -eq 0 ] ; then
   sleep 2
 else
   break
 fi
done
