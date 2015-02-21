stats
=====

NBCR statistics tracking

webstats
--------
A collection of html files that use google charts API for producing
stats about NBCR.  The stats can be used as separate web pages
and to produce image files for the reports. 
Move to repo website (graphene-nbcr/stats/)

scripts
--------
Move all scripts to opal roll
Scripts to aid NBCR stats collection.

* jobInfo-dump.sh - Dump opal jobs info into a file opaldb-DATE.out 
where DATE is constructed from the input arguments.

* countByService.sh - produce count opal invocations by application using specified input files 
for a specified year

* getGeoIP.py - takes an input file NAME of host IPs (one per line), and outputs 
count of country/state occurrences in files NAME-world (for world) and NAME-us (US)

* getIP.sh - parse apache logs and collect uniq hostips (duirng a given year),
output a file with uniq host ips, one per line. This file is used as an input
by getGeoIP.py script. 

* combineGeoCount.py - reads key and value (its count) from the input file and sums values for each found key.

* cronGetRemoteLogs.sh - get logs from another  opal server, run as cron

* cronOpalStats.sh - run opal stats for a month and update year stats up to that month

