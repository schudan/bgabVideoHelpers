#!/bin/bash

# Purpose: Use ffmpeg to normalize .m4a audio files to bring them up to max volume, if they at first have negative db volume. Doesn't process them if not. Keeps bitrate same as source files.
# Parameters: $1 should be the name of the directory containing input .m4a files.
#   $2 should be the output directory.

INPUTDIR=$1
OUTPUTDIR=$2

<<"COMMENT"

# For ffmpeg arguments http://superuser.com/questions/323119/how-can-i-normalize-audio-using-ffmpeg
# and
# https://kdecherf.com/blog/2012/01/14/ffmpeg-converting-m4a-files-to-mp3-with-the-same-bitrate/
ffmpeg -i test.m4a -af "volumedetect" -f null /dev/null

ffmpeg -i test.m4a -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume
# output: max_volume: -10.3 dB

ffmpeg -i test.m4a -af "volumedetect" -f null /dev/null 2>&1 | grep 'max_volume\|Duration'
# Output:
#  Duration: 00:00:02.14, start: 0.000000, bitrate: 176 kb/s
# [Parsed_volumedetect_0 @ 0x7f8531e011a0] max_volume: -10.3 dB

ffmpeg -i test.m4a -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1
# Output: -10.3

ffmpeg -i test.m4a 2>&1 | grep Audio
# output: Stream #0:0(und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 170 kb/s (default)

ffmpeg -i test.m4a 2>&1 | grep Audio | awk -F', ' '{print $5}' | cut -d' ' -f1
# output: 170

# This works, but I get a much smaller output file. The sound levels do appear normalized.
ffmpeg -i test.m4a -af "volume=10.3dB" -c:v copy -c:a aac -strict experimental output.m4a

# Operates quietly.
ffmpeg -i test.m4a -af "volume=10.3dB" -c:v copy -c:a aac -strict experimental -b:a 192k output.m4a -loglevel quiet

COMMENT

# $1 (first param) should be the name of a .m4a input file, with .m4a extension
# $2 should be name of output file, with extension
function normalizeAudioFile {
    INPUTFILE=$1
    OUTPUTFILE=$2

    DBLEVEL=`ffmpeg -i ${INPUTFILE} -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1`

    # We're only going to increase db level if max volume has negative db level.
    # Bash doesn't do floating comparison directly
    COMPRESULT=`echo ${DBLEVEL}'<'0 | bc -l`
    if [ ${COMPRESULT} -eq 1 ]; then
        DBLEVEL=`echo "-(${DBLEVEL})" | bc -l`
        BITRATE=`ffmpeg -i ${INPUTFILE} 2>&1 | grep Audio | awk -F', ' '{print $5}' | cut -d' ' -f1`

        # echo $DBLEVEL
        # echo $BITRATE

        ffmpeg -i ${INPUTFILE} -af "volume=${DBLEVEL}dB" -c:v copy -c:a aac -strict experimental -b:a ${BITRATE}k ${OUTPUTFILE} -loglevel quiet

    else
        echo "Already at max db level:" $DBLEVEL "just copying exact file"
        cp ${INPUTFILE} ${OUTPUTFILE}
    fi
}

for inputFilePath in ${INPUTDIR}/*; do
    inputFile=$(basename $inputFilePath)
    echo "Processing input file: " $inputFile
    outputFilePath=${OUTPUTDIR}/$inputFile
    normalizeAudioFile ${inputFilePath} ${outputFilePath}
done