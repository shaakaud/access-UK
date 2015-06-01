#/bin/bash

EXIT_ON_ERROR=1
BACKUP_PREPEND_PATH=/home/udayakut/bkup
SERVER=queen2.mv.usa.alcatel.com
PATCH_FILE_NAME=patchFile

if [ -z "$1" ] ; then
    echo "Supply Backup Dir Name"
    exit $EXIT_ON_ERROR
fi

if [ -n "$2" ] ; then 
   BACKUP_PREPEND_PATH=$2
fi

BACKUP_DIR=$BACKUP_PREPEND_PATH/$1

echo "Collecting cvsrw information ... "
cvsrw_output=$(cvsrw --cvs)
echo "$cvsrw_output"

echo ""
echo "checking edited files"
no_of_mod_files=$(echo "$cvsrw_output" | grep "M        w" | wc -l)
if [ "$no_of_mod_files" -eq 0 ] ; then 
    echo "No edited files!!"
    exit $EXIT_ON_ERROR
fi
echo "No of edited files : $no_of_mod_files"

echo "Creating folder $BACKUP_DIR in server: $SERVER"
ssh $SERVER mkdir $BACKUP_DIR
if [ $? -ne 0 ] ; then
    echo "Trouble in creating $BACKUP_DIR"
    exit $EXIT_ON_ERROR
fi

files_to_backup=$(echo "$cvsrw_output" | grep "M        w")
echo -e "Files being backed-up up are:\n$files_to_backup\n\n"

echo -n "Creating patch file.. "
cvs diff -u > patchFile 2> diffErrOp
echo "Done"
echo "Saving time of panos-dir creation"
ls -ld . > panos_time
echo "$cvsrw_output" > cvsrw_output
scp patchFile $SERVER:$BACKUP_DIR
scp diffErrOp $SERVER:$BACKUP_DIR
scp cvsrw_output $SERVER:$BACKUP_DIR
scp panos_time $SERVER:$BACKUP_DIR
rm patchFile diffErrOp cvsrw_output panos_time

no_of_new_files=$(echo "$cvsrw_output" | grep "?        w" | grep -v mkcsc.files.lst | wc -l)
NEW_FILES=$(echo "$cvsrw_output" | grep "?        w" | grep -v mkcsc.files.lst | awk '{ print $1 }')

if [ -n "$NEW_FILES" ] ; then
  echo "We have new files. No of new files : $no_of_new_files"
  echo $NEW_FILES
  ssh $SERVER mkdir $BACKUP_DIR/newfiles
  for i in $NEW_FILES ; do 
    base=$(dirname $i)
    ssh $SERVER mkdir -p $BACKUP_DIR/newfiles/$base
    scp $i $SERVER:$BACKUP_DIR/newfiles/$base
  done
fi

echo -e "\nBackup taken in $SERVER:$BACKUP_DIR/patchFile .. Be happy"

git log --pretty=oneline > gitstatus
commits=$(git log --pretty=oneline | wc -l)
commits=$(expr $commits - 1)
if [ $commits -gt 0 ] ; then 
  for i in $(seq 1 $commits ) ; do 
    j=$(expr $i - 1)
    git export HEAD~$j > patch_$j
  done
  ssh $SERVER mkdir -p $BACKUP_DIR/gitpatches
  scp gitstatus patch_* $SERVER:$BACKUP_DIR/gitpatches
fi
edited_files=$(git ls-files --modified | wc -l)
if [ $edited_files -ne 0 ] ; then
  git diff > patch_00
  ssh $SERVER mkdir -p $BACKUP_DIR/gitpatches
  scp patch_00 $SERVER:$BACKUP_DIR/gitpatches
fi
