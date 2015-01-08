#!/bin/bash 

if [ $# -eq 2 ]; then
    # dump for a year
    LENGTH=year
    DATE1=$1
    DATE2=$2
    NAME=$1-$2
else
    # show help
    echo "Usage: `basename $0` first last"
    echo "Dump opal jobs bor specified interval info into a file opaldb-DATE.out."
    echo "       first - for example 2013-01-01 "
    echo "       last  - for example 2013-02-01 "
    exit
fi

# db access
USER=opal
DB=opaldb
PASS=PUT-OPAL-PASS-HERE

SQL="/usr/bin/mysql $DB -u $USER --password=$PASS"

# output files
OUT=opaldb-$NAME.out
ERR=opaldb-$NAME.err

# run query
FIELDS="service_name, client_ip, user_email, code, message, start_time_date, start_time_time"
QUERY="select $FIELDS from job_info where start_time_date >= '$DATE1' and start_time_date <= '$DATE2' "
echo $QUERY | $SQL > $OUT 2>$ERR

