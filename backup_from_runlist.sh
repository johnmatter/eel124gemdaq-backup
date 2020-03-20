#!/usr/bin/env bash
runlist=/home/jmatter/eel124gemdaq-backup/runlist_test
data_dir=/data/raw
mss_dir=/mss/halla/sbs/GEM/cosmics/
cache_dir=/cache/halla/sbs/GEM/cosmics/

for run in $(cat $runlist); do
    echo ----------------------------------------
    echo Run $run
    echo
    files=$(find $data_dir -name "gem_cleanroom_$run.evio.*")
    for file in $files; do
        bname=$(basename $file)
        echo
        echo Backing up $bname

        cache_file=$cache_dir/$bname
        mss_file=$mss_dir/$bname

        # -----------------------------
        # Check if already backed up
        if [ -f "$mss_file" ]; then
            echo "$mss_file exists already"
            echo skipping
            continue
        fi

        # -----------------------------
        # Copy to /cache
        if [ -f "$cache_file" ]; then
            echo $cache_file exists already. skipping rsync
        else
            echo copying to /cache
            rsync -ah --progress $file $cache_dir
        fi

        # -----------------------------
        # jput to tape
        echo jput-ing
        ssh jmatter@ifarm1801 "jput $cache_file $mss_dir"
        echo

        # -----------------------------
        # Check md5 hash
        # Get backed-up version's hash
        mss_md5=$(cat $mss_file | grep md5 | sed "s/md5=//")

        # Get source hash
        source_md5=$(md5sum $file | awk '{print $1}')

        # Remove from /cache if hashes match
        if [[ "$mss_md5" == "$source_md5" ]]; then
            echo hashes match
            rm $cache_file
        else
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo "!! hashes don't match! Please investigate !!"
            echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        fi

    done
    echo
done
