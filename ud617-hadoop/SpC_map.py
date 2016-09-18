#!/usr/bin/python
import sys


def map():
   cols = { "date"    : 0,
            "time"    : 1,
            "store"   : 2,
            "cat"     : 3,
            "price"   : 4,
            "payment" : 5}
   for row in sys.stdin:
      fields = row.rstrip().split('\t')
      if len(fields) == 6:
         print "{}\t{}".format(fields[cols["cat"]],fields[cols["price"]])

# Code for standalone runs:
def main():
   map()

if __name__ == "__main__":
   main()


