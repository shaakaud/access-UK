#!/usr/bin/python

import commands
import subprocess
import os
import sys

pr = subprocess.Popen( "/usr/bin/git logol" , cwd = os.path.dirname( '~/ws/mg00/panos/' ), shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE )
(out, error) = pr.communicate()


print "Error : \n" + str(error) 
print "out : \n" + str(out)
