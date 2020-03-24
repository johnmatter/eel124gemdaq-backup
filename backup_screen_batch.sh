#!/usr/bin/env bash
# This script will create a screen session that will run
# the backup_from_fileslist.sh for all files named list(.*).txt.
# Each list gets its own window in the screen session.

the_date=$( date +%y%m%d%H%M )
session_name=backupsession$the_date

backup_script=/home/jmatter/eel124gemdaq-backup/backup_from_filelist.sh
list_dir=/home/jmatter/eel124gemdaq-backup

echo Creating $session_name
screen -d -m -S $session_name

for list in $(ls $list_dir/list*.txt); do
    window_name=$( basename $list | sed "s/.txt//" )

    echo Creating window for $list

    # create window
    screen -S $session_name -X screen -t $window_name

    # run backup script for this list
    screen -S $session_name -p $window_name -X exec $backup_script $list
done

echo Connecting to $session_name

# Connect and check that everything started fine
screen -x -S $session_name
