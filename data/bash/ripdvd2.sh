#!/bin/bash

beep -f 1400 -l 250

DVD="$1"
DVD_DIR="/media/dvd" # Mount location of dvd
DVD_DEV="/dev/sr0" # DVD Device
HANDBRAKE=HandBrakeCLI
LOG="logger -p daemon.info -t ripdvd2.sh --"

# Change this to reflect where you store your dvd rips
OUTDIR="/media/raid/videos/rips/completed/"

$LOG "Beginning rip of $DVD"
mount | grep "${DVD_DIR}" || mount "${DVD_DEV}" "${DVD_DIR}"
local LABEL=`file -s "$DVD" | cut -f 2- -d "'" | cut -f 1 -d "'" | sed -e 's/ *$//'`
$LOG "$DVD contains $LABEL"
$LOG $HANDBRAKE --verbose 9 --input "$DVD" --output "$OUTDIR/$LABEL.mkv" -e x264 --x264-preset ultrafast -a 1,2,3 -s 1,2,3
$HANDBRAKE --verbose 9 --input "$DVD" --output "$OUTDIR/$LABEL.mkv" -e x264 --x264-preset ultrafast -a 1,2,3 -s 1,2,3 2>&1 > $OUTDIR/HandBrake.log
#    $LOG $HANDBRAKE --verbose 9 --input "$DVD" --output "$OUTDIR/$LABEL.mkv" -a 1,2,3 -s 1,2,3
#    $HANDBRAKE --verbose 9 --input "$DVD" --output "$OUTDIR/$LABEL.mkv" -a 1,2,3 -s 1,2,3 2>&1 > $OUTDIR/HandBrake.log
umount "${DVD_DIR}" && eject "${DVD_DEV}"
eject

cd $OUTDIR

shopt -s nullglob
for file in *.{avi,rmvb,mkv,ogm,mp4}
do
      directory="${file%.*}"             # remove file extension 
      directory="${directory//_/ }"      # replace underscores with spaces

      darr=${directory}

      mkdir -p -- "$darr"           # create the directory; 
      mv -i -- "$file" "$darr"      # move the file to the directory

      if test "${USER}" = "root"; then
          chown -R keith.users "$darr"
      else
          sudo chown -R keith.users "$darr"
      fi
done


local STATUS="$?"
$LOG "Finished importing $LABEL from $DVD (status = $STATUS)"
return $STATUS

eject