#!/usr/bin/python
import sys

def reduce():
   sales = 0
   total = float(0)
   for row in sys.stdin:
      # assume map doesn't give us stupid output
      (key, value) = row.rstrip().split('\t')
      sales = sales + 1
      total = total + float(value)
   print "Total number of sales: {}".format(sales)
   print "Total value of sales:  {}".format(total)


# Code for standalone runs:
def main():
   reduce()

if __name__ == "__main__":
   main()

