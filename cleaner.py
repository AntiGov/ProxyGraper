#!/usr/bin/python
#Author: G66k @ MA
#Description: remove duplicate from two files

import sys

def main():
	if len(sys.argv) != 3:
		print("Usage: ./"+sys.argv[0]+" newfile oldfile")
		exit(0)
	new = oFile(sys.argv[1])
	old = oFile(sys.argv[2])
	print(clean(new,old))
	wFile(clean(new,old))
def clean(new,old):
	if type(new) is list or type(new) is tuple:
		new = set(new)
	if type(old) is list or type(old) is tuple:
		old = set(old)
	return new.difference(old)

def oFile(filename):
	with open(filename,'r') as file:
		return [x.strip() for x in file.readlines()]

def wFile(items):
	with open('cleanResult.txt','w') as file:
		for item in items:
  			file.write("%s\n" % item)
		file.close()

if __name__ == '__main__':main()
