#!/opt/python/bin/python

# combineGeoCount 
# Takes as an input a file  and sums counts for the same key.
# input file format (key-count pair per line):
#      CA 34
#      IL 45
# Creates key occurence count 
# writes output file with resulting counts in the format used by the 
# google.visualization.GeoChart():  ["Name", count],
# If -format=none is given on the command line a simpel format is used:
#     name count

import urllib2
import json
import os
import sys
from pprint import pprint


class Count:
    def __init__(self, argv):
        self.args = argv[1:]
        self.usageName  = os.path.basename(argv[0])
        self.setDefaults()

    def setDefaults(self):
        """ set default class attributes"""
        if len(self.args) < 2:
            self.help()
        self.input = self.args[0]                     # input file 
        self.output = self.args[1]                    # output file 

        self.format = "        [\"%s\", %d],\n"           # output format for key occurence count
        if len(self.args) == 3:
            str =  self.args[2]
            if str.lower().index('none'):
                self.format = "%s %d\n"               # simple output format for key occurence count

    def help(self):
        """ prints usage"""
        print '\nNAME: \n' , \
              '\t%s - reads key and its count from the input file and sums counts for each found key.\n' % self.usageName, \
              '\tOutputs count of occurences in the output file.\n' ,\
              '\nSYNOPSIS:\n' , \
              '\t%s  inFile outFile [-format=none] \n' % self.usageName, \
              '\nDESCRIPTION:\n' , \
              '\tinFile  - input file with keys counts (one  key-count pair per line) \n', \
              '\toutFile - output file with keys counts summed \n', \
              '\t-format=none - optional argument. If present the output format is "key value", for example: CA 34 \n', \
              '\t               Default format is:  ["CA", 3],  (for including resulting output in google chart html).\n', \
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


    def writeFile(self) :
        """ write output file in a specific format """
        text = ""
        for key, val in self.data.items(): 
            text += self.format % (key, val) 

        try:
            f = open(self.output, 'w')
            f.write (text)
            f.close()
        except IOError:
            print "Error writing file %s" % name


    def getCount(self):
        """ sum occurences counts  """
        self.readFile()
        data = {}
        for l in self.lines:
            code, count = l.split()
            if data.has_key(code):
                data[code] += int(count)
            else: 
                data[code] = int(count )
        self.data = data 
        self.writeFile()

    def run(self):
        """ main driver """
        self.getCount()
        sys.exit(0)

    def test(self):
        """ test  print variables """
        pprint (self.__dict__)

if __name__ == "__main__":
        app=Count(sys.argv)
        app.run()

