#!/bin/bash

len=60

x=""

dir="/media/video/Video/mixer/"

for i in $dir*.mp4
do
	x="$x $i -mix $len -mixer luma -mixer mix:-1"
done

x="melt -profile atsc_1080p_30 $x -consumer avformat:/media/video/Video/mixer/fade_$(date +%s).mp4 vcodec=libx264 vb=2500k "

#echo $x
eval $x

