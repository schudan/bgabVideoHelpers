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


# output dir
if not os.path.exists("output"): 
			os.mkdir("output")

# get mp3
mp3_files = [filename for filename in os.listdir(".") if filename.endswith(".mp3")]
mp3_files.sort()

# wrap mp3
subprocess.call(["mp3wrap"] + ["output/output.mp3"] + mp3_files)

# convert to aac
ffmpeg = 'ffmpeg -i output/output_MP3WRAP.mp3 -y -vn -acodec libvo_aacenc -ab 64k -ar 44100 -f mp4 output/output.aac'
subprocess.call(ffmpeg.split(" "))

# create chapters file
def secs_to_hms(seconds):
    h, m, s, ms = 0, 0, 0, 0
    
    if "." in str(seconds):
        splitted = str(seconds).split(".")
        seconds = int(splitted[0])
        ms = int(splitted[1])
    
    m,s = divmod(seconds,60)
    h,m = divmod(m,60)       

        
    ms = str(ms)
    try:
        ms = ms[0:3]
    except:
        pass   
    
    return "%.2i:%.2i:%.2i.%s" % (h, m, s, ms)

chapters_file = open('output/chapters', 'w')

counter = 0
time = 0

artist, album_title, title = None, None, None

for filename in mp3_files:
    audio = MP3(filename, ID3=EasyID3)
    title = audio["title"][0]
#    title = audio["album"][0]
    length = mad.MadFile(filename).total_time() / 1000. # don't use mutagen here, because it isn't very precise
    
    if not artist:
#        artist = audio["artist"][0]
#        album_title = audio["album"][0]
        try:
            artist = audio["artist"][0]
        except:
            pass   
        try:
            album_title = audio["album"][0]
        except:
            pass

        counter += 1
    
    chapters_file.write("CHAPTER%i=%s\n" % (counter, secs_to_hms(time)))
    chapters_file.write("CHAPTER%iNAME=%s\n" % (counter, title.encode('utf-8')))
    
    time += length

chapters_file.close()

os.chdir("output")

# add chapters and cover

subprocess.call(["MP4Box", "-add", "output.aac", "-chap", "chapters", "-itags", "cover=../cover.jpg", "output.mp4"])


# convert chapters to quicktime format
subprocess.call(["mp4chaps", "--convert", "--chapter-qt", "output.mp4"])


# clean up
os.remove("chapters")
os.remove("output.aac")
os.remove("output_MP3WRAP.mp3")

# create tags, rename file
audio = MP4("output.mp4")
audio["\xa9nam"] = [album_title]
audio["aART"] = [artist]
audio["\xa9alb"] = [album_title]
audio["\xa9wrt"] = [artist]
audio["\xa9gen"] = ["Audiobook"]
#audio["covr"] = ["../cover.jpg"]
audio.save()

os.rename("output.mp4", "../%s - %s.m4b" % (album_title, artist))
os.chdir("../")
uid = pwd.getpwnam("keith").pw_uid
gid = grp.getgrnam("users").gr_gid
path = "output"
os.chown(path, uid, gid)# output dir
os.chown("%s - %s.m4b" % (album_title, artist), uid, gid)
os.chmod("%s - %s.m4b" % (album_title, artist), 0o755)

shutil.rmtree('./output')

# get m4b
m4b_files = [filename for filename in os.listdir(".") if filename.endswith(".m4b")]

source_dir = '/media/raid/videos/conversion/00_temp/'
dst = "/media/raid/downloads/ebooks/audiobooks/Newest/"

# copy to audiobooks/newest
for filename in glob.glob(os.path.join(source_dir, '*.m4b')):
    shutil.copy(filename, dst)

for filename in glob.glob(os.path.join(dst, '*.m4b')):
    os.chown(filename, uid, gid)
    os.chmod(filename, 0o755)


print
print "File copied successfully."
print
print "Now use iTunes or gtkPod>=v0.99.14 to transfer the audio book to your iPod."
print
#Newest rev. Feb 28,2016