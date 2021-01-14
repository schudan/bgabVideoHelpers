#!/bin/sh

# Directory where file is located
DIR="/media/raid/videos/conversion/sonntag/"
ARCHIV="/media/raid/videos/conversion/sonntag/archiv/"
FTPDIR="/public_html/videos"
#  Filename of backup file to be transfered
SOURCE="/media/raid/videos/conversion/sonntag/sonntag.wmv"
FILE="sonntag.mp4"
FILE2="sonntag.ogg"
NOW=$(date +"%Y%m%d")

if [ -e $SOURCE ];
then

#----- Convert mpeg4

		ffmpeg -i /media/raid/videos/conversion/sonntag/sonntag.mp4 -vcodec mpeg4 -b 350k /media/raid/videos/conversion/sonntag/sonntag.mp4

#----- Convert ogg

		ffmpeg2theora /media/raid/videos/conversion/sonntag/sonntag.mp5

#----- Rename ogg to ogv

		cd $DIR
		mv "sonntag.ogv" "sonntag.ogg"

#----- Convert wmv to mp3

		ffmpeg -i /media/raid/videos/conversion/sonntag/sonntag.mpg -vn -ar 11025 -ac 2 -ab 40 -f mp3 /media/raid/videos/conversion/sonntag/sonntag.mp3

#----- Move files to archive

		mv "sonntag.wmv" "/media/raid/videos/conversion/sonntag/archiv/sonntag.mpg"
		mv "sonntag.mp4" "/media/raid/videos/conversion/sonntag/archiv/sonntag.mp4"
		mv "sonntag.ogg" "/media/raid/videos/conversion/sonntag/archiv/sonntag.ogg"
		mv "sonntag.mp3" "/media/raid/videos/conversion/sonntag/archiv/sonntag.mp3"

		cd /media/raid/videos/conversion/sonntag/archiv
		mv "sonntag.mp3" "$NOW.mp3"

#call to secondary script 
		./media/raid/daten/bash/FTPUpload.sh

#----- Move files to permanent archive

		cd /media/raid/videos/conversion/sonntag/archiv
		mv "$NOW.mp3" "/media/raid/videos/conversion/sonntag/archiv/mp3/$NOW.mp3"
		mv "sonntag.wmv" "/media/raid/videos/conversion/sonntag/archiv/video/$NOW.mpg"

else

  echo "No file to process"

fi