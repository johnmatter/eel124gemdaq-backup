#!/bin/bash
input="/home/jmatter/eel124gemdaq-backup/hashcheck"

# Create file descriptor
exec 5< $input

# Read lines 2 at a time and compare
while read line1 <&5; do
    read line2 <&5

    hash1=$(echo $line1 | awk  '{print $1}')
    hash2=$(echo $line2 | awk  '{print $1}')

    if [ "$hash1" != "$hash2" ]; then
        echo "mismatch"
        echo $line1
        echo $line2
    fi
done < "$input"
