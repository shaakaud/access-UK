#!/bin/sh
TEMP=c:/tmp
export TEMP
CSCOPE_DB=/home/spatward/ws/0.0-mg-1/cscope/cscope.out
export CSCOPE_DB
env | grep CSCOPE
gvim&
