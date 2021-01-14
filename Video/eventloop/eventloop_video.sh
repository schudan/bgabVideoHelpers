#!/bin/sh
dayName=`date +%a | tr '[:lower:]' '[:upper:]'`
if [ $dayName = "SO" ]
then
#    echo "WEEKEND"
	DIR=$(date +"%Y%m%d")
else
#    echo "other"
	DIR=$(date -d "next Sunday" +"%Y%m%d")
fi
#echo $DIR

#DIR=$(date -d "next Sunday" +"%Y%m%d")
#echo $DIR
ls -1 ./$DIR/*.png | xargs -n 1 bash -c 'convert "./$DIR/$0" "./$DIR/${0%.*}.jpg"'
rm -f ./$DIR/*.png
cd $DIR
ffmpeg -framerate 1/15 -s 1920x1080 -pattern_type glob -i '*.jpg' -r 5 -c:v libx264 -pix_fmt yuv420p /media/video/Video/foyerflat.mp4 -y
cd ..


