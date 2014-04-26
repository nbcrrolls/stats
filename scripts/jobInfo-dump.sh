#!/bin/bash 

if [ $# -eq 1 ]; then
    # dump for a year
    LENGTH=year
    DATE=$1-01-01
    NAME=$1
elif [ $# -eq 2 ]; then
    # dump for a month for a given year
    LENGTH=month
    DATE=$1-$2-01
    NAME=$1-$2
else
    # show help
    echo "Usage: `basename $0` year [month]"
    echo "Dump opal jobs info into a file opaldb-DATE.out where DATE is constructed from the input arguments:"
    echo "       year - 4 digit year. For example:  2013"
    echo "       month - optional 2 digit month (01 for Jan, 02 for Feb, etc.)"
    echo "               If omitted dump interval is for one year."
    exit
fi

# db access
USER=opal
DB=opaldb
PASS=PUT-PASS-HERE

SQL="/usr/bin/mysql $DB -u $USER --password=$PASS"

# output files
OUT=opaldb-$NAME.out
ERR=opaldb-$NAME.err

# run query
FIELDS="service_name, code, message, start_time_date, start_time_time, completion_time_date, completion_time_time, client_ip, user_email"
QUERY="select $FIELDS from job_info where start_time_date >= '$DATE' and start_time_date < '$DATE' + interval 1 $LENGTH"
echo $QUERY | $SQL > $OUT 2>$ERR

