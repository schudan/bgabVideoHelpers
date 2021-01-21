 #!/bin/bash         
#
echo "entered the file"
		mv "/media/raid/video/sonntag/sonntag/Sonntag.mpg" "/media/raid/video/sonntag/processed/Sonntag.mpg"
#mv /media/raid/video/conversion/sonntag /media/raid/video/conversion/processed
#ffmpeg -i /media/raid/video/conversion/to_1280x720/20160731.mpg -y -acodec  libfaac -ab 256k -ac 2 -s 1280x720 -codec:v mpeg4 -bf 1 -b:v 2567k -mbd 2 -g 300 -flags cgop /media/raid/video/conversion/converted/qt.mp4
echo "conversion complete"
#qt-faststart /media/raid/video/conversion/converted/qt.mp4 /media/raid/video/conversion/converted/output.mp4
#echo "qt-faststart"
#cd /media/raid/video/conversion/to_1280x720/;
#mv * /media/raid/video/conversion/processed/