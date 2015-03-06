#!/bin/sh
echo UDAY 
echo 1. Find files of interest and storing in cscope.files
find /home/udayakut/ws/mg00/panos/. -name "*.c" -o -name "*.h" > ../cscope.files
find /home/udayakut/ws/mg00/panos/. -name "*.cpp" >> ../cscope.files
find /home/udayakut/ws/mg00/panos/. -name "*.pasm" >> ../cscope.files
find /home/udayakut/ws/mg00/panos/. -name "*.inc" >> ../cscope.files
cd ../
echo 2. Removing old *.out
rm -f *.out 
export TEMP=c:/tmp
env
echo 3. Building cscope db
cscope -b -q
echo 4. exporting cscope.out to CSCOPE_DB
export CSCOPE_DB=/ws/mg00/cscope.out

