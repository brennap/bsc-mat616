#!/usr/bin/python
import sys

def reduce():
   oldkey = ""
   total = float(0)
   for row in sys.stdin:
      # assume map doesn't give us stupid output
      (key, value) = row.rstrip().split('\t')
      if oldkey == key:
         total = total + float(value)
      else:
         if oldkey != "":
            print "{}\t{}".format(oldkey,total)
         oldkey = key
         total = float(value)
   if oldkey == key:
      print "{}\t{}".format(key,total)


# Code for standalone runs:
def main():
   reduce()

if __name__ == "__main__":
   main()

