#!/bin/bash

# Parse apache logs for a given year and collect uniq hostips
# from which there was a request for web service. 
# create output file of uniq hostips for a year. 

# apache logs location
YEAR=2013
LOGDIR=/share/backup/apache_logs/$YEAR*
files=`ls $LOGDIR/access_log*`

# output file
OUT=ips$YEAR

touch $OUT
for i in $files
do
    grep POST $i | awk '{print $1}' | sort | uniq >> $OUT
done

sort $OUT | uniq > $OUT.uniq
