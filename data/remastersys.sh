#!/bin/bash
### Run remastersys periodically through cron, copy ISO-File to another location and clean up afterwards
### Simply change the following variables to fit your requirement, save and copy this script to e.g. cron.monthly. Make it executable and maybe test it by executing it like sudo ./SYSBU (or whatever you called it)....

### Settings ##
BACKUPDIR="/media/raid/data/backup_iso"          # path to backup-directory, don´t forget to exclude it in remastersys settings!!
DATE="$(date +%Y-%m-%d)"      # automatic date for mail, careful if you run this script and it finishes the other day, copy won´t work, as it of yourse looks for an actual date, so best start this script via cron in the early morning
FILENAME="SYSBU-$(date +%Y-%m-%d).iso"  # Filename will look like SYSBU-25-01-2010.iso, change order of %d, %m and %Y if you need it in another format.


# Now let´s go, change to root folder to avoid problems.

cd /

### Create backup directory ##
mkdir -p ${BACKUPDIR}

### Check if it worked and inform admin if it failed, you will need some mailserver like postfix installed on your system ##

if [ ! -d "${BACKUPDIR}" ]; then

mail -s "Backup directory not existant!" keithm107@bgab.de <<EOM
Hi Admin,
backup (${FILENAME}) at ${DATE} failed. Directory ${BACKUPDIR} was not found and could not be created. Check your mount options and availability of your harddrives!

Kind regards

Backupscript
EOM

 . exit 1
fi


### Now we run the necessary commands to create our system backup ##

### First a bit of cleaning just in case :-), anyway, it´s a quicky...

remastersys clean

# than we create the actual backup. Note the brackets [], don´t know if they are necessary but remastersys originally creates it, so why change it? This might take some bloody ages :-)

remastersys backup [iso] ${FILENAME}

### Check automatically if this process has been successful and mail admin in case of error. For our convenience, we are going to include the remastersys.log in our mail. Check correct path of this file if you changed anything in your remastersys configfile ##

if [ $? -ne 0 ]; then

mail -s "Backup (${FILENAME}) ended with error!" keithm107@bgab.de < /home/remastersys/remastersys.log <<EOM
Hi Admin,
your backup ${BACKUPNAME} on ${DATE} did exit with an error. Check attached log for reason.

Kind regards

Backupscript
EOM

 . exit 1
fi


### Now we copy our freshly created ISO-File to another location. Note the brackets [] again! If you changed the standard path of remastersys, you will have to edit this line to point to your remastersys directory too! If a new day is born meanwhile, FILENAME will not match, e.g. created file will be SYSBU-13-07-2010.iso but script will look for SYSBU-14-07-2010.iso as this has become the actual date. Yes this is annoying but I´m to lazy to change it...

cp /home/remastersys/remastersys/${FILENAME} ${BACKUPDIR}/${FILENAME}

### check if this has been successful

if [ $? -ne 0 ]; then

mail -s "Copy of backup (${FILENAME}) didn't succeed!" keithm107@bgab.de <<EOM
Hi Admin,
SYS-Backup ${FILENAME} on ${DATE} failed to copy for unknown reasons. Check sylog or dmesg or whatever :-)!

Kind regards

Backupscript
EOM

else
# if you get following message, everything is fine, except for cleaning up afterwards, which hasn´t been done yet...
 
mail -s "Backup (${FILENAME}) created and copied" keithm107@bgab.de <<EOM
Hi Admin,

Backup ${FILENAME} on ${DATE} hast been created and copied successfully.

Kind regards

Backupscript
EOM
### Now we clean up the mess and exit. Job´s done, your system might be safe, if your ISO is in working order!
remastersys clean
fi