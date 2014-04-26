#/bin/bash

# Run this scirpt to process opal/apache logs for a given year/month and create stats.
# Arguments: year (4 digit) and month (2 digit). 
# Default: (no arguments) do  processing for a previous month from a current date
# Run as a cron job at the beginning of a month

if [ $# -eq 1 ]; then
    # show help
    echo "Usage: `basename $0` [YEAR MONTH]"
    echo "Run logs processing scripts for a previous month of a current year (when all logs are collected)."
    echo "If both YEAR and MONTH are provided run processing for specified values."
    echo "The output files will be placed in \$YEAR/"
    echo "    YEAR  - 4 digit year.For example 2014"
    echo "    MONTH - 2 digit month. For example 01 for January"
    exit
elif [ $# -eq 2 ]; then
    # get year and month from arguments
    YEAR=$1
    MONTH=$2
else
    # find current year and prev month
    YEAR=`date +%Y`
    MONTH=`date --date "now -1 month" "+%m"`
fi

### Definitions ###

# sets working directory for all stats and logs
SetupWD () {
    BASE=/root/opal-stats
    if [ ! -d $BASE/$YEAR ]; then
        mkdir -p $BASE/$YEAR
    fi
    cd $BASE
}


# Creates opal jobs counts by service for a specified year/month
CountOpalJobs () {
    # dump opal jobs for month, creates opaldb-$YEAR-$MONTH.[out, err] files
    $BASE/jobInfo-dump.sh $YEAR $MONTH
    mv opaldb-$YEAR-$MONTH.* $YEAR

    # update opal invocations count, creates opal-onvocations file
    count=`wc -l $YEAR/opaldb-$YEAR*.out | grep total | awk '{print $1}'`
    header=`ls $YEAR/opaldb-$YEAR*.out | wc -l`
    let "total = count - header"
    echo $total > $YEAR/opal-invocations

    # update counts by service up to current month, creates by-service file
    $BASE/countByService.sh  $YEAR
}

# Create web services access geolocation counts by USstate/country from unique host ips 
# taken from apache logs for a specified month
CountIPs () {
    # parse apache logs for year/month and get uniq IPs, creates ips-$YEAR-$MONTH file with uniq IPs
    $BASE/getIP.sh $YEAR $MONTH

    # process uniq IPs file to get geolocation by US state or country, creates ips-$YEAR-$WORLD-[us,world] files
    $BASE/getGeoIP.py ips-$YEAR-$MONTH -format=none
    mv ips-$YEAR-$MONTH* $YEAR
}

# Create total counts for opal web services invocations, and us/world access by unique IP.
# Add counts from a second server if exist
UpdateAllCounts () {
    # update counts, will add stats from host
    HOST1=rocce-vm3

    # update opal invocations count
    FILE=$YEAR/by-service
    if [ -f $HOST1/$FILE ]; then
        cat $FILE $HOST1/$FILE > by-service-all
    else 
        cat $FILE > by-service-all
    fi
    $BASE/combineGeoCount.py by-service-all $YEAR/by-service-count
    rm -rf  by-service-all

    # check if second server counts are available
    if [ -d $HOST1/$YEAR ]; then
        us1=$HOST1/$YEAR/ips-$YEAR-??-us
        world1=$HOST1/$YEAR/ips-$YEAR-??-world
    else
        us1=
        workd1=
    fi

    # create US count by unique IP
    cat $YEAR/ips-$YEAR-??-us $us1 > us
    $BASE/combineGeoCount.py us  $YEAR/ips-us-sum
    rm -rf us

    # create world count by unique IP
    cat $YEAR/ips-$YEAR-??-world $world1 > world
    $BASE/combineGeoCount.py world  $YEAR/ips-world-sum
    rm -rf world
}

### Main ###
SetupWD
CountOpalJobs
CountIPs
UpdateAllCounts
