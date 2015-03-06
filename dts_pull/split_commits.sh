#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: $0 <file-having-many-commits>"
  exit 1
fi

COMMIT_FILE=$1

awk --posix '
BEGIN {
  current_blob=""
  blob_found_useful=0
  under_a_blob=0
}

/^[^[:space:]]/ {
  if ( blob_found_useful == 1 ) {
    file=author "_" date "_" time
    print "writing to file: ", file
    print current_blob > file
  }
  current_blob=""
  blob_found_useful=0
  under_a_blob=0
}

/^\*\*\[[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}/ {
  date=$1
  time=$2
  author=$3
  gsub(/\*/,"",date); gsub(/\[/,"",date); gsub(/-/,"_",date);
  gsub(/\*/,"",time); gsub(/:/,"_",time);
  gsub(/\]/,"",author);
  under_a_blob=1
}

/^    User: / {
  if (under_a_blob == 1) {
    blob_found_useful=1
  }
}

/^    new revision: / {
  if (under_a_blob == 1) {
    blob_found_useful=1
  }
}

( under_a_blob == 1 ) {
  current_blob = current_blob "\n" $0
}' $COMMIT_FILE


