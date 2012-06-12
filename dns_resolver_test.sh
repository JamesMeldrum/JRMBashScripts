#!/bin/sh
 
for i in "lifehacker.com" "facebook.com" "manu-j.com"  "reddit.com" "tb4.fr" "bbc.co.uk"
do
  for j in "4.2.2.2" "8.8.8.8" "208.67.222.222"
  do
    echo $j $i `dig @$j $i | grep Query | awk -F ":" '{print $2}'`
  done
done
