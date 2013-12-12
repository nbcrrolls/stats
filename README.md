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
Scripts to aid files the NBCR stats collection.

* getGeoIP.py - takes a file of hostips (one per line), and outputs 2 files with
corresponding country and state (the US) names occurences for these ips. 

* getIP.sh - parse apache logs and collect uniq hostips (duirng a given year),
output a file with uniq host ips, one per line. This file is used as an input
by getGeoIP.py script. 


