#!/bin/bash
#
#hjb_book_creation_script
#ver 0.1

beep -f 1400 -l 250

admin () {
		clear
		mkdir -p $cfg_workingDir
		logs=$cfg_workingDir/$cfg_FIN_m4b_NAME"_creation.log"
		rm -f $cfg_workingDir/*.mp3 $cfg_workingDir/*.png $cfg_workingDir/*.log $cfg_workingDir/*.m4b
		rm -f $cfg_DIR_SOURCE/*MP3WRAP*
		dd if=/dev/zero bs=44100 count=1 | lame -t -r -b 64 -m m - $cfg_workingDir/silence-fallback.mp3
		clear
		if [ $cfg_dummy -eq 0 ]
		then
				echo "Starting to encode $cfg_FIN_m4b_NAME" > "$logs" 2>&1
			else
				echo "Doing a dummy run on $cfg_FIN_m4b_NAME" > "$logs" 2>&1
		fi
		echo "Using the config file: "$IN_CFG >> "$logs" 2>&1
		echo "The following is the order in which the files will be wrapped! " >> "$logs" 2>&1
		echo "Starting to encode $cfg_FIN_m4b_NAME"
}

calc_time () {
		S=$1
		((h=S/3600))
		((m=S%3600/60))
		((s=S%60))
		calcTime=`printf "%dh:%dm:%ds\n" $h $m $s`	
}



create_watermark () {
		convert /tmp/white_hat.png -fill grey50  miff:- | \
		composite -dissolve 50 -gravity northeast - "$cfg_Picture" "$cfg_workingDir/wmark_dissolve_grey.png"
		convert "$cfg_workingDir/wmark_dissolve_grey.png" -resize 480x320\>  "$cfg_workingDir/pic.png"
}

encode_book () {
		echo "Encoding part "$book" of the book"
		echo "Encoding part "$book" of the book" >> "$logs" 2>&1
		midTag="-"
		ffOUT="book_MP3WRAP.mp4"
		if [ $cfg_dummy -eq 0 ]
		then
			ffmpeg -i $cfg_workingDir/album_MP3WRAP.mp3 -y -vn -acodec aac -strict experimental -ab 64k -ar 44100 -threads 3 -f mp4 "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mp4chaps -rz "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mp4chaps -Qe $cfg_CHAPTERS_AT "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mp4tags -r "s a e E A t P" "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mp4tags -s "$cfg_Name" -a "$cfg_Artist" -c "$cfg_Comment" -e "$cfg_Encoded" -g "$cfg_Genre" -L "$cfg_Lyrics" -E "$cfg_Tool" "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mp4art -z --add "$cfg_workingDir/pic.png" "$cfg_workingDir/$ffOUT" >> "$logs" 2>&1
			mv "$cfg_workingDir/$ffOUT" "$cfg_workingDir/$cfg_FIN_m4b_NAME$midTag$1.m4b"	
		fi
}

get_book_lengths () {
		CNT=0
		DURATION=0
		tDURATION=0		
		cd $cfg_DIR_SOURCE
		for IN_FILE in *.mp3; do 
			echo $IN_FILE >> "$logs" 2>&1
			let "CNT = ( CNT + 1 )"
			DURATION_HMS=$(ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')
			DURATION_HMS=`echo $DURATION_HMS|sed 's/^0*//'`
			DURATION_H=$(echo "$DURATION_HMS" | cut -d ':' -f 1)
			DURATION_H=`echo $DURATION_H|sed 's/^0*//'`
			DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 2)
			DURATION_M=`echo $DURATION_M|sed 's/^0*//'`
			DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 3 | cut -d '.' -f 1)
			DURATION_S=`echo $DURATION_S|sed 's/^0*//'`
			let "DURATION = ( DURATION_H * 60 + DURATION_M ) * 60 + DURATION_S +1"
			let "tDURATION = ( tDURATION + DURATION )"				
		done
		
		echo "Total mp3 files to wrap: "$CNT >> "$logs" 2>&1
		variableA=$((tDURATION/cfg_TOTAL_BOOKS+10))
		calc_time $variableA
		echo "What follows is calculated from your config file. It might turn out differently ):" >> "$logs" 2>&1
		echo "Average length per part: " $calcTime >> "$logs" 2>&1
		variableB=$((tDURATION/variableA+1))
		echo  "Books to create: " $variableB >> "$logs" 2>&1		
		calc_time $tDURATION
		cfg_Comment=$cfg_Comment" Running time: "$calcTime
		echo "This book reads:  "$calcTime" in total" >> "$logs" 2>&1
		echo "This book reads:  "$calcTime" in total"
		variableC=$((tDURATION/63))
		calc_time $variableC
		echo "It will take approximately:  "$calcTime" to create" >> "$logs" 2>&1
		echo "It will take approximately:  "$calcTime" to create"
		echo "------------------------------------------------------------------------" >> "$logs" 2>&1
}

main_loop () {
		book=1
		CNT=0
		fp=0		
		DURATION=0
		tDURATION=0	
		cd $cfg_DIR_SOURCE

		for IN_FILE in *.mp3; do 
			echo "File being processed. "$IN_FILE
			let "CNT = ( CNT + 1 )"
			DURATION_HMS=$(ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')
			DURATION_HMS=`echo $DURATION_HMS|sed 's/^0*//'`
			DURATION_H=$(echo "$DURATION_HMS" | cut -d ':' -f 1)
			DURATION_H=`echo $DURATION_H|sed 's/^0*//'`
			DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 2)
			DURATION_M=`echo $DURATION_M|sed 's/^0*//'`
			DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 3 | cut -d '.' -f 1)
			DURATION_S=`echo $DURATION_S|sed 's/^0*//'`
			let "DURATION = ( DURATION_H * 60 + DURATION_M ) * 60 + DURATION_S +1"
			let "tDURATION = ( tDURATION + DURATION )"

				if [ $tDURATION -gt $variableA ] 
				then
						if [ ! -f "$cfg_workingDir/album_MP3WRAP.mp3" ]
							then
								echo "Huge mp3 found. Simulate wrap and move on." >> "$logs" 2>&1
								cp "$IN_FILE" $cfg_workingDir/album_MP3WRAP.mp3
								fp=1								
							else
								mp3wrap -a $cfg_workingDir/album_MP3WRAP.mp3 "$IN_FILE" >> "$logs" 2>&1
						fi				

					calc_time $tDURATION
					
					echo "########################################################" >> "$logs" 2>&1
					echo "Book "$book" consist of "$CNT" mp3s." >> "$logs" 2>&1
					echo "It is "$calcTime >> "$logs" 2>&1
					echo "########################################################" >> "$logs" 2>&1
					encode_book $book

					STOPMP=`date -u "+%s"`
					RUNTIMEM=`expr $STOPMP - $STARTMP`
					if (($RUNTIMEM>59)); then
						TTIMEM=`printf "%dm%ds\n" $((RUNTIMEM/60%60)) $((RUNTIMEM%60))`
						else
						TTIMEM=`printf "%ds\n" $((RUNTIMEM))`
					fi	

					variableC=$((variableC-RUNTIMEM))	
					calc_time $variableC	
					if [ $cfg_dummy -eq 0 ]
					then
						echo "This part took: $TTIMEM" >> "$logs" 2>&1
						echo "This part took: $TTIMEM"
						echo "Approximate time left to finish: "$calcTime >> "$logs" 2>&1
						echo "Approximate time left to finish: "$calcTime
					fi
					echo "++++++++++++++++++++++++++++++++++++++++++++++" >> "$logs" 2>&1
					STARTMP=$STOPMP
					let "book = ( book + 1 )"
					rm $cfg_workingDir/*MP3WRAP*
					DURATION=0
					tDURATION=0
					fp=0
					CNT=0
				else					
					if [ $fp -eq 0 ]
						then
							mp3wrap $cfg_workingDir/album.mp3 $cfg_workingDir/silence-fallback.mp3 "$IN_FILE" >> /dev/null 2>&1
							fp=1
						else
							mp3wrap -a $cfg_workingDir/album_MP3WRAP.mp3 "$IN_FILE" >> "$logs" 2>&1
					fi
				fi				
		done
		calc_time $tDURATION
		if [ ! $tDURATION -eq 0 ]
		then		
			echo "########################################################" >> "$logs" 2>&1
			echo "Book "$book" consist of "$CNT" mp3s." >> "$logs" 2>&1
			echo "It is "$calcTime >> "$logs" 2>&1
			echo "########################################################" >> "$logs" 2>&1
			encode_book $book
		else
				echo "Over run because of Big Files: Force STOP. Duration time for next encode is: " $tDURATION >> "$logs" 2>&1
		fi

}

start () {
		cfg_workingDir="" # dont change this here
		SCRIPT_NAME="${0##*/}"
		SCRIPT_DIR="${0%/*}"
		if test "$SCRIPT_DIR" == "." ; then
			  SCRIPT_DIR="$PWD"
			elif test "${SCRIPT_DIR:0:1}" != "/" ; then
			  SCRIPT_DIR="$PWD/$SCRIPT_DIR"
		fi

		for IN_CFG in $SCRIPT_DIR/bcs*.cfg; do 
			STARTM=`date -u "+%s"`
			STARTMP=`date -u "+%s"`
			cfg_Name=""
			cfg_Artist=""
			cfg_Comment=""
			cfg_Encoded=""
			cfg_Tool=""
			cfg_Genre=""
			cfg_Lyrics=""
			cfg_Picture=""
			cfg_DIR_SOURCE=""
			cfg_FIN_m4b_NAME=""
			cfg_TOTAL_BOOKS=""
			cfg_CHAPTERS_AT=""
			if [ ! -f "$IN_CFG" ]
				then
					clear
					echo "Please create a config file in the same folder as this script!"
					echo "It must look something like this:"
cat <<EOF

cfg_dummy=0
cfg_workingDir="/tmp/book"
cfg_Name="ABC For Children (Book 1 - The Beginning)"
cfg_Artist="Mrs Y"
cfg_Comment="Narrated by Mr X."
cfg_Encoded="hjb"
cfg_Tool="hjb_book_creation_script"
cfg_Genre="Audiobook"
cfg_Lyrics="blah blah blah blah"
cfg_Picture="/tmp/ev.jpg"
cfg_DIR_SOURCE="/Media/Books/Book-A_B_C"
cfg_FIN_m4b_NAME="The ABC Book"
cfg_TOTAL_BOOKS=3
cfg_CHAPTERS_AT=1200

You must save it in the same directory as your hjb_book_creation_script
and name it bcsXXX.cfg, where the XXX can be any number.
If there are more than one config files they will be used sequentially.
If the dummy variable is not 0 no actual encoding will happen which may result in some errors in the log files

EOF
					exit
			fi
			source $IN_CFG
			if [ -z $cfg_workingDir ]
				then
					clear
					echo "Please correct config file!"
					exit
			fi
			admin
			get_book_lengths
			create_watermark
			main_loop

			STOPM=`date -u "+%s"`
			RUNTIMEM=`expr $STOPM - $STARTM`
			if (($RUNTIMEM>59)); then
				TTIMEM=`printf "%dm%ds\n" $((RUNTIMEM/60%60)) $((RUNTIMEM%60))`
				else
				TTIMEM=`printf "%ds\n" $((RUNTIMEM))`
			fi
				echo "++++++++++++++++++++FINISHED++++++++++++++++++++++++" >> "$logs" 2>&1
			if [ $cfg_dummy -eq 0 ]
				then
					echo "This audio book creation took: $TTIMEM" >> "$logs" 2>&1
					echo "This audio book creation took: $TTIMEM"
			fi
		done
}

start

		
