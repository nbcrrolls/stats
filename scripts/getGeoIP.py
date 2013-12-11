#!/opt/python/bin/python

# MapperIP: counts the occurence of access by unique host IP
# Takes as an input a file (one hostip per line), 
# contacts http://freegeoip.net/json  service and finds a country/state for each ip. 
# Creates country occurence count and US state occurence count and
# writes counts in the format used by the  google.visualization.GeoChart()
#            ["Name", count],
# into <input>-world and <input>-us files. 

import urllib2
import json
import os
import sys
from pprint import pprint


class MapIP:
    def __init__(self, argv):
        self.args = argv[1:]
        self.usageName  = os.path.basename(argv[0])
        self.setDefaults()

    def setDefaults(self):
        """ set default class attributes"""
        self.service = "http://freegeoip.net/json/%s" #  use json service
        self.region = []                              # count of occurences by country
        self.regionUS = []                            # count of occurences by US state
        self.extCountry = "-world"                    # suffix to use for file output name by country
        self.extUS = "-us"                            # suffix to use for file output name by US state
        self.format = "    [\"%s\", %d],\n"           # output format for country/state and occurence count
        if len(self.args) < 1:
            self.help()
        self.input = self.args[0]                     # file with host ips


    def help(self):
        """ prints usage"""
        print '\nNAME: \n' , \
              '\t%s - reads hostip(s) from the input file and finds a corresponding country/state.\n' % self.usageName, \
              '\tOutputs count of country/state occurences in files IPS%s (world) and IPS%s (US)\n' % (self.extCountry, self.extUS) ,\
              '\nSYNOPSIS:\n' , \
              '\t%s  IPS  \n' % self.usageName, \
              '\nDESCRIPTION:\n' , \
              '\tIPS - hostip file (one per line) \n', \
        sys.exit(0)


    def readFile(self):
        """ read input file """
        try:
            f = open(self.input, 'r')
            self.lines = f.readlines()
            f.close()
        except IOError:
            print "Error reading file %s" % self.input
            return None


    def writeFile(self, name, dict):
        """ write output file in a specific format """
        if dict == {}:
            print "INFO: no text to write into a file %s" % name
            return

        text = ""
        for key, val in dict.items(): 
            text += self.format % (key, val) 

        try:
            f = open(name, 'w')
            f.write (text)
            f.close()
        except IOError:
            print "Error writing file %s" % name


    def getRegion(self):
        """ find hostip' country and state (for US) """
        self.readFile()
        data = []
        dataUS = []
        for i in self.lines:
            ip = i[:-1]
            print ip
            try:
                loc = json.load(urllib2.urlopen(self.service % ip))
            except urllib2.HTTPError, error:
                print error.read()
                continue
            country = loc['country_code'].encode('ascii', 'ignore')
            if len(country):
                data.append(country)             # list of countries
            if country == "US": 
                state = loc['region_code'].encode('ascii', 'ignore')
                if len(state):
    	            dataUS.append(state)         # list of states

        self.region = self.occurence(data)       # find occurence number by country
        self.regionUS = self.occurence(dataUS)   # find occurence number by US state

    def printByRegion(self):
        """ write occurence by country and state files """
        byCountry = self.input + self.extCountry
        byState = self.input + self.extUS
        self.writeFile(byCountry, self.region)
        self.writeFile(byState, self.regionUS)


    def occurence(self, data):
        """ find occurence number of a list item """
        d = {}
        for i in data:
            if i in d:
                d[i] = d[i]+1
            else:
                d[i] = 1
        return d

    def run(self):
        """ main driver """
        self.getRegion()
        self.printByRegion()
        sys.exit(0)

    def test(self):
        """ test  print variables """
        pprint (self.__dict__)

if __name__ == "__main__":
        app=MapIP(sys.argv)
        app.run()

