#!/bin/bash
###########################################################################
#
#   Filename:           ftpxfer.mk
#
#   Author:             Anon
#   Created:            08/01
#
#   Description:        Wrapper for the Windows FTP.EXE program
#
#
# Usage:
#   ftpxfer.sh [-passive] server user password <get|put> srcfile [dstfile]
#
#
###########################################################################
#
#                 Source Control System Information
#
#   $Id: ftpxfer.sh,v 1.13 2006/03/28 18:27:57 mbs Exp $
#
###########################################################################
#
#              Copyright (c) 2001-2006 TiMetra, Inc., Alcatel
#
###########################################################################

passive=0
ascii=0

while [ "$1" != "" ]
do
    if [ "$1" = "-ascii" ]
    then
        ascii=1
        shift
        continue
    fi

    if [ "$1" = "-passive" ]
    then
        passive=1
        shift
        continue
    fi

    # not a recognized option, so must be done with them
    break
done

server="$1"
shift
user="$1"
shift
pass="$1"
shift
cmd="$1"
shift
srcfile="$1"
shift
dstfile="$1"

if [ "$srcfile" = "" ]
then
    echo "Usage: ftpxfer.sh [-passive] [-ascii]"
    echo "                   server user pass [get|put|mkdir|del] arg [arg2]"
    exit 1
fi
if [ "$dstfile" = "" ]
then
    dstfile="$srcfile"
fi

mkdir -p ${SYSTEMDRIVE}/tmp

#
# Log in
#
echo -e "user ${user} ${pass}\n" > /tmp/$$ftp.tmp
chmod 666 /tmp/$$ftp.tmp
if [ $passive -ne 0 ]
then
    echo -e "passive\n" >> /tmp/$$ftp.tmp
fi
if [ $ascii -ne 0 ]
then
    echo -e "ascii\n" >> /tmp/$$ftp.tmp
else
    echo -e "binary\n" >> /tmp/$$ftp.tmp
fi

#
# Do one of the ftp commands
#
code=221
if [ "$cmd" = mkdir ]
then
    echo -e "mkdir $srcfile\n" >> /tmp/$$ftp.tmp
    code=257
fi
if [ "$cmd" = dele -o "$cmd" = del -o "$cmd" = rm ]
then
    echo -e "dele $srcfile\n" >> /tmp/$$ftp.tmp
    code=250
fi
if [ "$cmd" = get ]                     
then
    echo -e "get $srcfile $dstfile" >> /tmp/$$ftp.tmp
    code=226
fi
if [ "$cmd" = put ]
then
    echo -e "put $srcfile $dstfile\n" >> /tmp/$$ftp.tmp
    code=226
fi

#
# Quit
#
echo -e "quit\n" >> /tmp/$$ftp.tmp

# Make the ftp program do it
ftp </tmp/$$ftp.tmp -vdin "$server" >/tmp/$$ftpxfer.txt 2>&1
status=$?
chmod 666 /tmp/$$ftpxfer.txt

if [ $status -eq 0 ]
then
    # Hope to find success result code
    grep -q "^$code " /tmp/$$ftpxfer.txt
    status=$?
    # And, if we find a failure code, then it's bad.
    grep -q "^550 " /tmp/$$ftpxfer.txt
    if [ $? -eq 0 ]
    then
        status=1
    fi
    # If we did not get expected code, or got 550 fail code, complain
    if [ $status -ne 0 ]
    then
        echo "!!! Warning - FTP transfer did not complete correctly !!! "
        status=77
    fi
else
    echo ""
    echo "!!! FTP failed with status $status"
    echo ""
fi

# Show log of FTP transfer indented a few spaces for readability
if [ $status -ne 0 ]
then
    cat /tmp/$$ftpxfer.txt | sed -e 's/^/    /'
    echo ""
    cp /tmp/$$ftpxfer.txt /tmp/ftpxferfail.txt
fi

# Make copies for debugging - why? Removed 3/21/06
#cp -f /tmp/$$ftpxfer.txt /tmp/ftpxfer.txt
#cp -f /tmp/$$ftp.tmp /tmp/ftp.tmp

rm -f /tmp/$$ftpxfer.txt
rm -f /tmp/$$ftp.tmp

exit $status
