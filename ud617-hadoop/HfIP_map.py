#!/usr/bin/python
import sys
import re

def map():
   #re.compile('(\d*\.\d*\.\d*\.\d*) (\S*) ([^[]*) \[([^[]*)\] \"([A-Z]*) (\S*) (\S*)\" (\d*) ([-0-9]*)')
   reg = re.compile('(?P<ip>\d*\.\d*\.\d*\.\d*) (?P<id>\S*) (?P<user>[^[]*) \[(?P<time>[^[]*)\] \"(?P<oper>[A-Z]*) (?P<page>\S*) (?P<proto>\S*)\" (?P<status>\d*) (?P<size>[-0-9]*)')
   #                 ^------------IP----------^ ^---id----^ ^----user-----^  ^------time------^   ^--operation---^ ^---page----^ ^--protocol--^   ^---status----^ ^---size--------^
   for row in sys.stdin:
      fields = re.match(reg, row)
      if fields != None:
         print "{}\t{}".format(fields.group('ip'),fields.group('status'))
      else:
         sys.stderr.write("Error: Could not parse row:\n\t"+row)

# Code for standalone runs:
def main():
   map()

if __name__ == "__main__":
   main()


