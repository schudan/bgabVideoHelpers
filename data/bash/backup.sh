#!/bin/bash
   
  echo "These Directories will be excluded:"
  echo -e "\033[1m\033[32m /proc /lost+found */backup.tgz /media /mnt /sys /dev"
  echo -e "\033[0m"
  echo "Backing up PC ~ timestamp " ;date
  cd /
  cdate=$(date +%Y-%m-%d)
  tar cpzf /media/raid/data/backup_iso/backup_${cdate}.tgz --exclude=/dev --exclude=/proc --exclude=/home/keith/.gvfs --exclude=/lost+found --exclude=*/backup.tgz  --exclude=/media --exclude=/mnt --exclude=/run --exclude=/sys --exclude=/tmp --exclude=/var/cache --exclude=/var/spool /