#!/usr/bin/env bash

mss_dir=/mss/halla/sbs/GEM/cosmics
cache_dir=/cache/halla/sbs/GEM/cosmics
source_dir=/data/raw


runlist=$1

for run in $(cat $runlist); do
    echo ----------------------------------------
    echo Run $run

    files=$(./get_files_for_run.sh $run)

    for file in $files; do
        bname=$(basename $file)

        mss_file=$mss_dir/$bname
        cache_file=$cache_dir/$bname
        source_file=$source_dir/$bname

        # Get backed-up version's hash
        mss_md5=$(cat $mss_file | grep md5 | sed "s/md5=//")

        # Get source hash
        source_md5=$(md5sum $source_file | awk '{print $1}')

        echo
        echo $mss_md5 $mss_file
        echo $source_md5 $source_file

    done
    echo
    echo
done
