#!/usr/bin/python
#Author: G66K @ MA
#Description: remove specific domain from domainlist

import re
import sys

def main():
	if (len(sys.argv)) != 3:
		print("Usage: ./" + sys.argv[0] + " EmailList.txt ResultFile.txt")
		exit(0)

	mails = oFile(sys.argv[1])
	for mail in mails:
		if re.search(r'gmail.|yahoo.|live.|hotmail.|aol.|outlook.|rocketmail.|mail.ru',mail,re.I):
			print("match: " + mail)
		else:
			wFile(mail)


def oFile(filename):
	with open(filename,'r') as file:
		return set([x.strip() for x in file.readlines()])

def wFile(item):
	with open(sys.argv[2],'a') as file:
  		file.write("%s\n" % item)
		file.close()

if __name__ == '__main__':main()
