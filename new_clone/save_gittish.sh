#!/bin/bash

git log --pretty=oneline | head -n -1 > gitstatus
for i in $(seq 1 $(cat gitstatus | wc -l)) ; do ii=$(expr $i - 1); git show --pretty=format: HEAD~$ii | tail -n +2 > patch_$ii ; done
lines=$(git ls-files --modified | wc -l)
if [ $lines -gt 0 ] ; then
  git diff > patch_00
fi
