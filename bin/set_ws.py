#!/usr/bin/python

######################
# Usage:
# mcd <search string>
# search string - Any substring of the folders under ~/ws/
# Eg: set_ws.py 90 <= Lists all the folders under ~/ws/ which has
# subscring "90". Asks the choice. Then changes the folder to that ws.
######################

import commands
import subprocess
import os
import sys

home = os.environ['HOME']
wsdir = home+'/ws/'
ws =  os.listdir(home+'/ws/')

#ws folder validation
if os.path.isdir('/home/udayakut/ws') is False:
    print "Folder not present - %s" %wsdir
    sys.exit(0)

args = sys.argv[1:]

#branch validation
if len(args) < 1:
    print "Enter branch search string"
    sys.exit(0)
branch = args[0]

if branch != '00' and branch != '80' and branch != '90' and branch != 'vh' and branch != '10s':
    print "Wrong branch - %s" %branch
    sys.exit(0)

count = 1
dir_dict = {}
for dir in ws:
    if branch in dir:
        if 'vh' in branch or 'vh' not in dir:
            dir_dict[count] = dir
            print "%u. %s" % (count, dir_dict[count])
            count = count + 1
#Print last option as quit
dir_dict[count] = "quit"
print "%u. %s" % (count, dir_dict[count])
 
user_input = input('\nEntery your choice:')
if type(user_input) != int:
    print "Your input is not a number. Restart the program"
    sys.exit(0)

#If quit option is chosen, stop the program
if (user_input == count):
    sys.exit(0)

ws_path = os.path.join(wsdir, dir_dict[user_input])
if ('vh' in dir_dict[user_input]):
    ws_full_path = ws_path
else:
    ws_full_path = os.path.join(ws_path, 'panos/')

#Write the ws path in /tmp/mcd
file_mcd = "/tmp/mcd"
try:
    file = open(file_mcd, 'r+')
except:
    file = open(file_mcd, 'w')

file.truncate(0)
file.write(ws_full_path)
print ws_full_path
