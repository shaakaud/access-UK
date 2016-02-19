#!/usr/bin/python

import commands
import subprocess
import os
import sys
import re

args = sys.argv[1:]
if not args:
    print 'usage: workspace-name'
    sys.exit(1)

wspath = os.environ['HOME'] +  '/ws/' + args[0] + '/panos/'
print wspath

#Just like that initializing head/origin UUID
head = 0
origin = 0

iccrx_tags = {'iccrx_tip':head, 'iccrx_base':origin}

#Delete the tags if present
for k in iccrx_tags.keys():
    if not subprocess.call(["git", "tag", "-d", k], cwd = os.path.dirname(wspath)):
        print k, 'tag deleted'
    else:
        print k, 'tag NOT present and hence NOT deleted'

pr = subprocess.Popen( "/usr/bin/git logol" , cwd = os.path.dirname(wspath), shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
(out, error) = pr.communicate()

#Match the HEAD
hmatch = re.search(r'\*\s(\w+)\s\(HEAD', out)
if hmatch:
    head = hmatch.group(1)
    iccrx_tags['iccrx_tip'] = head
    print 'head is', head
else:
    print 'HEAD not match'

#Match the origin
omatch = re.search(r'\*\s(\w+)\s\(origin', out)
if hmatch:
    origin = omatch.group(1)
    iccrx_tags['iccrx_base'] = origin
    print 'origin is', origin
else:
    print 'origin not match'

#Add the new tags
for k in iccrx_tags.keys():
    subprocess.call(["git", "tag", k, iccrx_tags[k]], cwd = os.path.dirname(wspath))
    print k,'->',iccrx_tags[k], '*  added'

#print "Error : \n" + str(error)
#print "out : \n" + str(out)
