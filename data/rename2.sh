#!/bin/bash

# Directory where file is located
DIR="/media/raid/videos/rips/completed/"

cd $DIR

shopt -s nullglob
for file in *.{avi,rmvb,mkv,ogm,mp4}
do
  directory="${file%.*}"             # remove file extension 
  directory="${directory//_/ }"      # replace underscores with spaces

 darr=${directory}
 
 darr="${darr/ cd1}"
 darr="${darr/ cd2}"
 darr="${darr/ CD1}"
 darr="${darr/ CD2}"
 srt="${file%.*}.srt"
 echo "$srt"

  echo "$darr"
  mkdir -p -- "$darr"           # create the directory; 
  mv -i -- "$file" "$darr"      # move the file to the directory

	if [ -f "$srt" ]
	then
	 	mv -i -- "$srt" "$darr"      # move the srt file to the directory
	fi
 
done