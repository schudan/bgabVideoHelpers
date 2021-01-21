#!/bin/bash

# Directory where file is located
DIR="/media/raid/videos/conversion/sonntag/"
ARCHIV="/media/raid/videos/conversion/sonntag/archiv/"
FTPDIR="/public_html/videos"
#  Filename of backup file to be transfered
SOURCE="/media/raid/videos/conversion/sonntag/sonntag.wmv"
FILE="sonntag.mp4"
FILE2="sonntag.ogg"
NOW=$(date +"%Y%m%d")

cd $DIR

echo "hello"