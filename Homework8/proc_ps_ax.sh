#!/bin/bash

for i in $(ls -d /proc/[0-9]* | sort -V);
  do
     PID="$(basename $i)"
     if [ -f "$i/cmdline" ] && [ "`awk 'END { print (NR > 0 && NF > 0) ? "1" : "0"}' $i/cmdline`" == "1" ]
     then
       echo -ne "$(basename $i)\t" \
       && awk -F'[ ()]' '{ printf $5 "\t"}' $i/stat 
       awk '{ if(match($NF,/[a-z]+/)) printf $NF; }' $i/cmdline && echo; 
     else
       if [ -f "$i/comm" ] && [ "`awk 'END { print (NR > 0 && NF > 0) ? "1" : "0"}' $i/comm`" == "1" ]
       then
         echo -ne "$(basename $i)\t" \
         && awk -F'[ ()]' '{ printf $5 "\t"}' $i/stat 
         awk '{ if(match($NF,/[a-z]+/)) printf $NF; }' $i/comm && echo;
       fi
     fi
done
