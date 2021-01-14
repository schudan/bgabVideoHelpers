#!/bin/bash
# sh /media/video/data/bash/eventloop_slides.sh
#dayName=`date +%a | tr '[:lower:]' '[:upper:]'`
if [[ $(date +%u) -gt 6 ]];
then
#    echo "Sunday"
	DIR=$(date +"%Y%m%d")
else
#    echo "other"
	DIR=$(date -d "next Sunday" +"%Y%m%d")
fi

chmod -R 0777 ./$DIR

len=60

x=""

dir="/media/video/Video/eventloop/$DIR"

ls -1 $dir/*.png | xargs -n 1 bash -c 'convert "$dir/$0" "$dir/${0%.*}.jpg"'
rm -f $dir/*.png


cp $dir/01.jpg $dir/zz99_loopend.jpg



for i in $dir/*.jpg
do
	if [ "$i" = "$dir/01.jpg" ]
	then
		x="$x $i out=70 "
	else
		x="$x $i out=360 -mix $len -mixer luma "
	fi
done
echo $dir
echo $x
# test Zeile - um die Einstellungen zu überprüfen
#x="melt -profile atsc_1080p_30 $x -consumer avformat:$dir/fade_$(date +%s).mp4 vcodec=mpeg4 vb=2400k "
x="melt -hide-audio -profile atsc_1080p_30 $x -consumer avformat:/media/video/Video/foyerflat.mp4 vcodec=mpeg4 vb=10500k "

#echo $x
eval $x

#ffmpeg -i /media/video/Video/foyerflat.mp4 -c copy -an /media/video/Video/foyerflat.mp4 2> /dev/null
#rm /media/video/Video/foyerflat.mp4
#mv /media/video/Video/foyerflat02.mp4 /media/video/Video/foyerflat.mp4
