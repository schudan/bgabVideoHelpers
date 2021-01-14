 #!/bin/bash         
#
echo "entered the file"
#cd "/media/raid/video/sonntag/sonntag/"
#		mv "/processed/*" "/sonntag/Sonntag.mpg"
#mv /media/raid/video/conversion/processed/*" "media/raid/video/conversion/sonntag/Sonntag.mpg"
#ffmpeg -i "/media/raid/video/sonntag/sonntag/Sonntag.mpg" -y -acodec  libfaac -ab 256k -ac 2 -s 1280x720 -codec:v mpeg4 -bf 1 -b:v 2567k -mbd 2 -g 300 -flags cgop "/media/raid/video/sonntag/converted/qt.mp4"
#ffmpeg -i "/media/raid/video/sonntag/sonntag/Sonntag.mpg" -y -acodec  libfaac -ab 128k -ac 2 -vcodec libx264 -b:v 1500k -filter:v crop=700:566:10:0 "/media/raid/video/sonntag/converted/cropped.mp4"
ffmpeg -i "/media/raid/video/sonntag/sonntag/Sonntag.mpg" -y -vcodec libx264  -crf 20 -c:a libvo_aacenc -b:a 128k  -vf scale="480:-1" "/media/raid/video/sonntag/converted/sonntag.mp4"
echo "conversion complete"
#qt-faststart /media/raid/video/conversion/converted/qt.mp4 /media/raid/video/conversion/converted/output.mp4
#echo "qt-faststart"
#cd /media/raid/video/conversion/to_1280x720/;
#mv * /media/raid/video/conversion/processed/