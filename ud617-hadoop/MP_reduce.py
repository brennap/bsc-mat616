#!/usr/bin/python
import sys

def reduce():
   oldkey = ''
   count = 0
   pop = ''
   popcount = 0
   for row in sys.stdin:
      # assume map doesn't give us stupid output
      (key, value) = row.rstrip().split('\t')
      if oldkey == key:
         count = count + 1
      else:
         if oldkey != "":
            if count > popcount:
               pop = oldkey
               popcount = count
         oldkey = key
         count = 1
   if oldkey == key:
      if count > popcount:
         pop = oldkey
         popcount = count
   print "{}\t{}".format(pop,popcount)



# Code for standalone runs:
def main():
   reduce()

if __name__ == "__main__":
   main()

