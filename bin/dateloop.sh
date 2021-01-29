#!/bin/bash

# simple script to loop bash command over a date range

currentdate=$1
loopenddate=$(/bin/date --date "$2 1 day" +%Y-%m-%d)

until [ "$currentdate" == "$loopenddate" ]
do
  echo $currentdate
  currentdate=$(/bin/date --date "$currentdate 1 day" +%Y-%m-%d)
done
