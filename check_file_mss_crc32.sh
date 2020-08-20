#!/usr/bin/env bash
# "file" should be the basename, not the full path

file=$1
mss_dir=/mss/halla/sbs/GEM/cosmics
cache_dir=/cache/halla/sbs/GEM/cosmics
source_dir=/data/raw

mss_file=$mss_dir/$file
cache_file=$cache_dir/$file
source_file=$source_dir/$file

# Get backed-up version's hash
mss_crc32=$(cat $mss_file | grep crc32 | sed "s/crc32=//")

# Get source hash
source_crc32=$(crc32 $source_file | sed "s/^0*//")

echoawk '{print $1}'
echo $mss_crc32 $mss_file
echo $source_crc32 $source_file
echo

if [[ "$mss_crc32" == "$source_crc32" ]]; then
	echo hashes match

	echo "Do you want to delete $cache_file?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes)
				rm $cache_file
				break;;
			No)
				break;;
		esac
	done
else
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!! hashes don't match! Please investigate !!"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi
