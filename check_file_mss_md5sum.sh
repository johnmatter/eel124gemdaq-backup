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
mss_md5=$(cat $mss_file | grep md5 | sed "s/md5=//")

# Get source hash
source_md5=$(md5sum $source_file | awk '{print $1}')

echo
echo $mss_md5 $mss_file
echo $source_md5 $source_file
echo

if [[ "$mss_md5" == "$source_md5" ]]; then
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
