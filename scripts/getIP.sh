#!/bin/bash

# Parse apache logs for a given year/month and collect uniq hostips
# from which there was a request for web service. 
# create output file of uniq hostips for a year/moth. 

if [ $# -eq 2 ]; then
    YEAR=$1
    MONTH=$2
else
    # show help
    echo "Usage: `basename $0` year month"
    echo "Parse apache logs for a given year and month. Output file is ips-\$year-\$month"
    echo "       year - 4 digit year. For example:  2013"
    echo "       month - 2 digit month. For example: 01 for Jan, 02 for Feb, etc."
    exit
fi

# apache logs location
LOGDIR=/share/backup/apache_logs/$YEAR$MONTH*
files=`ls $LOGDIR/access_log*`

# output file
OUT=ips-$YEAR-$MONTH
TEMP=ips-$YEAR-$MONTH.temp

touch $TEMP
for i in $files
do
	grep POST $i | grep 'meme\|pdb2pqr\|autoclickchem\|opal2' | awk '{print $1}' | sort | uniq >> $TEMP
done

sort $TEMP | uniq > $OUT
rm -rf $TEMP
