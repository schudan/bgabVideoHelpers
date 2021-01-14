#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This file is in the Public Domain.
# Copyright (C) 2010 Benjamin Elbers <elbersb@gmail.com>
# 
# Takes all mp3 files in the current directory and creates a properly tagged
# audio book (m4b) with chapter marks in the "output" directory.
#
# Note: The mp3 files should have proper ID3 tags. The "title" tag of each mp3
#       file is used as the corresponding chapter title. The "artist" and 
#       "album" tags of the first file are used as tags for the complete 
#       audio book.
# Note: To have the chapters in the correct order, the filenames have to be
#       sortable (e.g. "01 - First chapter.mp3", "02 - Second chapter.mp3"). 
# Note: To make the chapter marks show up on the iPod use gtkPod>=v0.99.14 or
#       iTunes for transferring the audio book.
#
# Requires: ffmpeg, MP4Box, mp4chaps, mutagen, libmad, mp3wrap


from mutagen.easyid3 import EasyID3
from mutagen.mp3 import MP3
from mutagen.mp4 import MP4
import mad
import time
import os
import subprocess
import pwd
import grp
import os
from shutil import copyfile
import shutil
import glob

# get m4b
m4b_files = [filename for filename in os.listdir(".") if filename.endswith(".m4b")]

source_dir = '/media/raid/videos/conversion/00_temp/'
dst = "/media/raid/downloads/ebooks/audiobooks/Newest/"

# copy to audiobooks/newest
for filename in glob.glob(os.path.join(source_dir, '*.m4b')):
    shutil.copy(filename, dst)


print
print "File copied successfully."
print
print "Now use iTunes or gtkPod>=v0.99.14 to transfer the audio book to your iPod."
print