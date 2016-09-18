#!/usr/bin/python
import sys

def reduce():
   oldkey = ''
   count = 0
   for row in sys.stdin:
      # assume map doesn't give us stupid output
      (key, value) = row.rstrip().split('\t')
      if oldkey == key:
         count = count + 1
      else:
         if oldkey != "":
            print "{}\t{}".format(oldkey,count)
         oldkey = key
         count = 1
   if oldkey == key:
      print "{}\t{}".format(oldkey,count)


# Code for standalone runs:
def main():
   reduce()

if __name__ == "__main__":
   main()

