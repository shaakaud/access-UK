#!/bin/sh

bkup_filename=$1
bkup_dir=$HOME/bkup
vb_win_dir=/drive_c/$bkup_dir
bkup_file_path=$bkup_dir/$bkup_filename
remote_bkup_server='queen2.mv.usa.alcatel.com'

echo "Bakup file name is $bkup_file_path"

git diff @{u}.. > $bkup_file_path

if $(uname -a | grep -qi linux)
then
    if [ -d "$DIRECTORY" ]; then
        cp $bkup_file_path $vb_win_dir/$bkup_filename
    fi
fi

echo "Local backup done as $bkup_file_path"

scp $bkup_file_path $USER@$remote_bkup_server:$bkup_file_path

echo "Transferred $bkup_filename to $USER@$remote_bkup_server:$bkup_file_path"

echo "DONE"
