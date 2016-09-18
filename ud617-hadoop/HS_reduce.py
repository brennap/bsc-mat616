#!/usr/bin/python
import sys

def reduce():
   oldkey = ""
   highest = float(0)
   for row in sys.stdin:
      # assume map doesn't give us stupid output
      (key, value) = row.rstrip().split('\t')
      if oldkey == key:
         highest = max(highest, float(value))
      else:
         if oldkey != "":
            print "{}\t{}".format(oldkey,highest)
         oldkey = key
         highest = float(value)
   if oldkey == key:
      print "{}\t{}".format(key,highest)


# Code for standalone runs:
def main():
   reduce()

if __name__ == "__main__":
   main()

