#!/usr/bin/env bash
data_dir=/data/raw

run=$1

files=$(find $data_dir -name "gem_cleanroom_$run.evio.*")
for file in $files; do
    echo $file
done
