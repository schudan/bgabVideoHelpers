#!/bin/bash
#
#hjb_book_creation_script
#ver 0.1

beep -f 1400 -l 250

cd /media/raid/videos/conversion/to_audiobook/;
find -name "* *" -type f | rename 's/ /_/g';
#for 1 in *' '*; do   mv "$1" `echo $i | sed -e 's/ /_/g'`; done

B=$(basename "$1");

DATER=`date +%Y%m%d_%H%M%S`
OUTPUT=`date +%Y%m%d_%H%M%S_audiobook`
SETS=64k
OUTPUT=${B%.*}_${SETS}_${DATER}
OUTPUTDIR=/media/raid/videos/conversion/converted/
OUTPUT2=`date +%Y%m%d_%H%M%S_block`
BLOCKDIR=/media/raid5/video/conversion/converted/block
BLOCK= `block`

ffmpeg -i $1 -y -vn -acodec aac -strict experimental -ab 64k -ar 44100 -threads 3 -f mp4 $OUTPUTDIR$OUTPUT.mp4  1>/media/raid/videos/conversion/converted/block.txt 2>&1;

#----- Rename files

#		mv "$OUTPUTDIR$OUTPUT.mp4" "$OUTPUTDIR$OUTPUT.m4b"

#rm $OUTPUTDIR$OUTPUT.mp4

mv $1 /media/raid/videos/conversion/processed/



#beep -f 1000 -l 500
sh /media/raid/data/bash/tetris.sh
