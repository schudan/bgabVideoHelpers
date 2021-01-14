#!/bin/bash

# PURPOSE: Script to check temperature of CPU cores and report/shutdown if specified temperatures exceeded
#
# AUTHOR: feedback[AT]HaveTheKnowHow[DOT]com

# Expects two arguments:
#    1. Warning temperature
#    2. Critical shutdown temperature
#    eg. using ./CPUTempShutdown.sh 30 40
#        will warn when temperature of one or more cores hit 30degrees and shutdown when either hits 40degrees.

# NOTES:
# Change the strings ">>/home/keith" as required
# Substitute string "myemail@myaddress.com" with your own email address in the string which starts "/usr/sbin/ssmtp myemail@myaddress.com"

# Assumes output from sensors command is as follows:
#
# coretemp-isa-0000
# Adapter: ISA adapter
# Core 0:      +35.0 C  (high = +78.0 C, crit = +100.0 C)  
#
# coretemp-isa-0001
# Adapter: ISA adapter
# Core 1:      +35.0 C  (high = +78.0 C, crit = +100.0 C) 
#
# if not then modify the commands str=$(sensors | grep "Core $i:") & newstr=${str:14:2} below accordingly

echo "JOB RUN AT $(date)"
echo "======================================="

echo ''
echo 'CPU Warning Limit set to => '$1
echo 'CPU Shutdown Limit set to => '$2
echo ''
echo ''

sensors

echo ''
echo ''

for i in 0 1
do

  str=$(sensors | grep "Core $i:")
  newstr=${str:14:2}

  if [ ${newstr} -ge $1 ]
  then
    echo '============================'                             >>/home/keith/Desktop/CPUWarning.Log
    echo $(date)                                                    >>/home/keith/Desktop/CPUWarning.Log
    echo ''                                                         >>/home/keith/Desktop/CPUWarning.Log
    echo ' WARNING: TEMPERATURE CORE' $i 'EXCEEDED' $1 '=>' $newstr >>/home/keith/Desktop/CPUWarning.Log
    echo ''                                                         >>/home/keith/Desktop/CPUWarning.Log
    echo '============================'                             >>/home/keith/Desktop/CPUWarning.Log
  fi
  
  if [ ${newstr} -ge $2 ]
  then
    echo '============================'
    echo ''
    echo 'CRITICAL: TEMPERATURE CORE' $i 'EXCEEDED' $2 '=>' $newstr
    echo ''
    echo '============================'
    /sbin/shutdown -h now
    /usr/sbin/ssmtp keithm107@bgab.de </media/raid/data/myscripts/cpumsg.txt
    echo 'Email Sent.....'
    exit
  else
    echo ' Temperature Core '$i' OK at =>' $newstr
    echo ''
  fi
done

echo 'Both CPU Cores are within limits'
echo ''




