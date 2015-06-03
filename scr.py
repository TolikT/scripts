#!/usr/bin/env python 
# coding: utf8

import os
import re
import sys

dictionary = {}
category = raw_input("Введите категорию: ")
directory = raw_input("Введите путь к директории: ")

try:
	for name in os.listdir(directory):
		f = open(os.path.join(directory,name), 'r')
		for line in f:	
			fields = re.split('[\t ]+',line)
			if fields[0] == category:
				if fields[1] in dictionary: dictionary[fields[1]]+= int(fields[2])
				else: dictionary[fields[1]] = int(fields[2])
		f.close

	for item in dictionary:
		print item, dictionary[item]
except:
    print "Error! ", sys.exc_info()

exit
