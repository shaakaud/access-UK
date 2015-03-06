#!/bin/sh
echo SUDEEP 
find /home/spatward/ws/0.0-mg-1/panos/. -name "*.c" -o -name "*.h" > ../cscope/cscope.files
find /home/spatward/ws/0.0-mg-1/panos/. -name "*.cpp" >> ../cscope/cscope.files
find /home/spatward/ws/0.0-mg-1/panos/. -name "*.pasm" >> ../cscope/cscope.files
find /home/spatward/ws/0.0-mg-1/panos/. -name "*.inc" >> ../cscope/cscope.files
cd ../cscope
rm -f *.out 
export TEMP=c:/tmp
env
cscope.exe -b -q
export CSCOPE_DB=/ws/0.0-mg-1/cscope/cscope.out

