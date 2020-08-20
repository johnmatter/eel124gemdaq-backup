#!/usr/bin/env bash

mss_dir=/mss/halla/sbs/GEM/cosmics
cache_dir=/cache/halla/sbs/GEM/cosmics
source_dir=/data/raw


run=$1

files=$(./get_files_for_run.sh $run)

for file in $files; do
    bname=$(basename $file)

    mss_file=$mss_dir/$bname
    cache_file=$cache_dir/$bname
    source_file=$source_dir/$bname

    # Get backed-up version's hash
    mss_crc32=$(cat $mss_file | grep crc32 | sed "s/crc32=//")

    # Get source hash
    source_crc32=$(crc32 $source_file | sed "s/^0*//")

    echo
    echo $mss_crc32 $mss_file
    echo $source_crc32 $source_file

done
