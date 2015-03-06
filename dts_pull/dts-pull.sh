#!/bin/bash

USER=lnara002
PASSWD=findout
PASSWD_SCRAMBLER=/Users/lnara002/cygwin/repo-of-scripts/dts-pull/cvs-descramble.py
HTML_TO_TEXT=/Users/lnara002/cygwin/repo-of-scripts/dts-pull/htmltotext.py
#DTS_FOLDER=/Users/lnara002/cygwin/dts-pulls
DTS_FOLDER=/home/lnara002/ws/dts


if [ $# -ne 1 ] ; then 
  echo "Usage: $0 <dts-number>"
  exit 1
fi

DTS=$1
echo "Using DTS: $DTS"

mkdir -p $DTS_FOLDER/$DTS
cd $DTS_FOLDER/$DTS

tempfile=$(mktemp)
cookiefile=${tempfile}_cookie

PASSWD=$($PASSWD_SCRAMBLER "$(sed -n 's/.*cvsrep \(.*\)/\1/p' ~/.cvspass)")
LOGIN_URL="https://sso.mv.usa.alcatel.com/login.cgi"
URL="https://dts.mv.usa.alcatel.com/dts/cgi-bin/viewReport.cgi?&report_id=$DTS&reportDetail=detail"
SUBREPORT_URL_PREFIX="https://dts.mv.usa.alcatel.com/dts/cgi-bin/viewReport.cgi?&report_id=$DTS&subreport_id="

DISCARD=$(curl --silent --cookie-jar $cookiefile $LOGIN_URL -b auth_probe=1 --insecure  --form-string "username=$USER" --form-string "password=$PASSWD")

DTS_MAIN_PAGE=$(curl -b $cookiefile --silent -w "%{http_code}" --insecure --user "$USER:$PASSWD" "$URL" 2>&1)
echo "$DTS_MAIN_PAGE" > /tmp/dts_main_page

SUBREPORTS=$(echo "$DTS_MAIN_PAGE" | sed -rn 's/.*;subreport_id=(.*)">.*/\1/p')
echo "$SUBREPORTS"

subreport_file=${tempfile}_subrep
for i in $SUBREPORTS ; do 
  rm -f $subreport_file
  URL_SUBREPORT=${SUBREPORT_URL_PREFIX}$i 
  SUBREPORT=$(curl -b $cookiefile --silent -w "%{http_code}" --insecure --user "$USER:$PASSWD" "$URL_SUBREPORT" 2>&1)
  echo "$SUBREPORT" > $subreport_file
  $HTML_TO_TEXT $subreport_file | sed -n '/Developer Notes/,$p' > subreport_$i
done

rm $cookiefile
