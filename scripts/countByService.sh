#!/bin/bash 
# 
# Count opal opal web services invocations by application
# using files prodiced by jobInfo-dump.sh
# Output file by-service is placed in  a year directory 

if [ $# -eq 1 ]; then
    # check year
    NAME=$1
else
    # show help
    echo "Usage: `basename $0` YEAR"
    echo "Find all files opaldb-DATE.out for a requested year and count opal invocations by application."
    echo "The output file is by-service"
    echo "       YEAR - 4 digit year. For example:  2013"
    exit
fi

if [ ! -d $NAME ]; then
    echo "Directory $NAME does not exist"
    exit
fi

c=`ls $NAME/opaldb-$NAME*out | wc -l`
echo "Processing $c files in $NAME/"

cat $NAME/opaldb-$NAME*.out | awk '{print $1}' > app-names
sort app-names | grep -v service_name | uniq --count | awk '{print $2, $1}' > $NAME/by-service
rm -rf app-names

