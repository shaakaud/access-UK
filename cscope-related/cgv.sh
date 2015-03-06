#!/bin/sh
TEMP=c:/tmp
export TEMP
CSCOPE_DB=/home/udayakut/ws/mg00/cscope.out
export CSCOPE_DB
env | grep CSCOPE
gvim&
