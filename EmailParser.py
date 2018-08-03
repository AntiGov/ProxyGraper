#!/usr/bin/python
"""
Coded by Iroi Yagami

keep it private or sell it and get Rich!

"""
import re
import sys

def main():
	if len(sys.argv) != 3:
		print("Usage:" + sys.argv[0] + "input.txt output.txt")
		sys.exit(0)

	fileInput = sys.argv[1]

	regex = r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b:[a-zA-Z0-9]+"
	
	count  = 1
	
	for line in rFile(fileInput):
  		if re.match(regex, line, re.I):
	    		print ("{}) Found: {}".format(count, line))
			count += 1
			wFile(line)
def rFile(file):
	with(open(file)) as fhandle:
		return [line.strip('\n') for line in fhandle.readlines()]

def wFile(line):
	fhandle = open(sys.argv[2], "a+") 
        fhandle.write(line+"\n")
	fhandle.close()
if __name__ == '__main__':main()        
