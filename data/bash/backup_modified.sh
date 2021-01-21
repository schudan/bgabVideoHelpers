#!/bin/sh

# Make incremental backup - 

rsync -av /boot /media/backups/backups
rsync -av /etc /media/backups/backups
rsync -av /home /media/backups/backups
rsync -av /root /media/backups/backups
rsync -av /usr /media/backups/backups
rsync -av /var /media/backups/backups