#!/bin/bash
# Directory where file is located
#DIR="/media/raid"
#
#cd ..
#cd $DIR
#cd /media/raid/videos/rips/completed/
#cd /media/raid/
#
#shopt -s nullglob
#for file in *.{avi,rmvb,mkv}
#do
#  directory="${file%.*}"             # remove file extension 
#  directory="${directory//_/ }"      # replace underscores with spaces
#  darr=( $directory )
#  darr="${darr[@]^}"                 # capitalize the directory name
#
#  mkdir -p -- "$darr"           # create the directory; 
#  mv -b -- "$file" "$darr"      # move the file to the directory
# 
#done

# Directory where file is located
DIR="/media/raid/videos/conversion/sonntag/"
ARCHIV="/media/raid/videos/conversion/sonntag/archiv/"
FTPDIR="/public_html/videos"
#  Filename of backup file to be transfered
SOURCE="/media/raid/videos/conversion/sonntag/sonntag.wmv"
FILE="sonntag.mp4"
FILE2="sonntag.ogg"
NOW=$(date +"%Y%m%d")



#----- Rename ogg to ogv

		cd $DIR