#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: $0 <file-having-just-one-commit-info>"
  exit 1
fi

COMMIT_FILE=$1

echo $COMMIT_FILE

awk '
/<--/ { 
  file=$1 ; 
  match (file, "\\[(.*)\\]", arr) ; file=arr[1] ; 
  sub(",v","",file); sub("/swdev/cvsrep/","",file); sub("Attic/","",file);
  cmd="basename " file ; cmd | getline basename ;    
  cmd="dirname " file ; cmd | getline dirname ; 
  getline ; 
  rev=$6 ; 
  cmd="mkdir -p " dirname ; system(cmd) ; 
  cmd="cvs checkout -p -r" rev " " file " > " file ; system(cmd) 
}'  $COMMIT_FILE
mkdir -p ${COMMIT_FILE}_dir/old
mv panos ${COMMIT_FILE}_dir/old
find ${COMMIT_FILE}_dir/old -type f | xargs chmod -w

awk '
/<--/ { 
  file=$1 ; 
  match (file, "\\[(.*)\\]", arr) ; file=arr[1] ; 
  sub(",v","",file); sub("/swdev/cvsrep/","",file); sub("Attic/","",file);
  cmd="basename " file ; cmd | getline basename ;    
  cmd="dirname " file ; cmd | getline dirname ; 
  getline ; 
  rev=$3 ; 
  sub(";","",rev) ; 
  cmd="mkdir -p " dirname ; system(cmd) ; 
  cmd="cvs checkout -p -r" rev " " file " > " file ; 
  system(cmd) 
}' $COMMIT_FILE
mkdir -p ${COMMIT_FILE}_dir/new
mv panos ${COMMIT_FILE}_dir/new
find ${COMMIT_FILE}_dir/new -type f | xargs chmod -w

