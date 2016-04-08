#!/bin/sh

bkup_filename=$1
bkup_gitdiff_filename=$1_gitdiff
bkup_dir=$HOME/bkup
vb_win_dir=/drive_c/$bkup_dir
remote_bkup_server='queen2.mv.usa.alcatel.com'

git diff @{u} > $bkup_dir/$bkup_filename
git diff > $bkup_dir/$bkup_gitdiff_filename

if $(uname -a | grep -qi linux)
then
    if [ -d "$DIRECTORY" ]; then
        cp $bkup_dir/$bkup_filename $vb_win_dir/$bkup_filename
        cp $bkup_dir/$bkup_gitdiff_filename $vb_win_dir/$bkup_gitdiff_filename
    fi
fi

scp $bkup_dir/$bkup_filename $USER@$remote_bkup_server:$bkup_dir/$bkup_filename
scp $bkup_dir/$bkup_gitdiff_filename $USER@$remote_bkup_server:$bkup_dir/$bkup_gitdiff_filename

echo "Local Bakup file Path"
echo "    $bkup_dir/$bkup_filename"
echo "    $bkup_dir/$bkup_gitdiff_filename"

echo "Remote Bakup file Path"
echo "    $USER@$remote_bkup_server:$bkup_dir/$bkup_filename"
echo "    $USER@$remote_bkup_server:$bkup_dir/$bkup_gitdiff_filename"

echo "DONE"
