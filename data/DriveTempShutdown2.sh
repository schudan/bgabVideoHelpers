#!/bin/bash


echo "JOB RUN AT $(date)"
echo '============================'

echo ''
echo 'Drive Warning Limit set to =>' $1
echo 'Drive Shutdown Limit set to =>' $2
echo ''
echo ''

if [ $# -eq 2 ]
then
  MyList='a b c d e'
  echo 'Testing all drives'
else 
  MyList=($3)
  echo 'Testing only the system drive'
fi

echo ''

for i in $MyList
do
  echo 'Drive /dev/sd'$i
  /usr/sbin/smartctl -n standby -a /dev/sd$i | grep Temperature_Celsius
done

echo ''
echo ''

for i in $MyList
do
 #Check state of drive 'active/idle' or 'standby'
  stra=$(/sbin/hdparm -C /dev/sd$i | grep 'drive' | awk '{print $4}')

  echo 'Testing Drive sd'$i

  if [ ${stra} = 'standby' ]
  then 
    echo '    Drive sd'$i 'is in standby'
    echo ''
  else

    str1='/usr/sbin/smartctl -n standby -a /dev/sd'$i
    str2=$($str1 | grep Temperature_Celsius | awk '{print $10}')

    if [ ${str2} -ge $1 ]
    then

      echo '============================'					>>/home/keith/Desktop/Drives.Log
      echo $(date)                                                    		>>/home/keith/Desktop/Drives.Log
      echo ''									>>/home/keith/Desktop/Drives.Log
      echo 'WARNING: TEMPERATURE FOR DRIVE sd'$i 'EXCEEDED' $1 '=>' $str2	>>/home/keith/Desktop/Drives.Log
      echo ''									>>/home/keith/Desktop/Drives.Log
      echo '============================'					>>/home/keith/Desktop/Drives.Log
    fi

    if [ ${str2} -ge $2 ]
    then

      echo '============================'
      echo ''
      echo 'CRITICAL: TEMPERATURE FOR DRIVE sd'$i 'EXCEEDED' $2 '=>' $str2
      echo ''
      echo '============================'
      /sbin/shutdown -h now
      /usr/sbin/ssmtp keithm107@bgab.de </media/raid/data/myscripts/drivemsg.txt
      echo 'Email Sent.....'
      exit
    else

      echo '    Temperature of Drive '$i' is OK at =>' $str2
      echo ''
    fi
  fi
done

echo 'All Drives are within limits'
echo ''

