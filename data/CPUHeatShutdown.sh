#!/bin/bash

echo "JOB RUN AT $(date)"
echo "======================================="

# sensors

echo ''
#echo ''



#date >> /home/keith/Desktop/CoreWarning.Log
### Temperature Monitor
### Auto Shutdown if CPU Temperature is over threshold
### heri.cahyono@gmail.com

## Define threshold for CPU Temperature
threshold=85

## Get CPU Temperatur using lm-sensor
t1=`/usr/bin/sensors | nawk '/temp1/ {print substr($2,2,2)}'`
t2=`/usr/bin/sensors | nawk '/temp2/ {print substr($2,2,2)}'`

if test $t1 -gt $threshold || test $t2 -gt $threshold
then
    echo '============================'                             >>/home/keith/Desktop/CoreWarning.Log
    echo $(date)                                                    >>/home/keith/Desktop/CoreWarning.Log
    echo 'CPU Temp is exceeding threshold – Shutting down in 5 sec …….' >>/home/keith/Desktop/CoreWarning.Log
    echo ''                                                         >>/home/keith/Desktop/CoreWarning.Log
    echo "Core1: $t1°C"                                             >>/home/keith/Desktop/CoreWarning.Log
    echo "Core2: $t2°C"                                             >>/home/keith/Desktop/CoreWarning.Log
    echo ''                                                         >>/home/keith/Desktop/CoreWarning.Log
    echo '============================'                             >>/home/keith/Desktop/CoreWarning.Log
    mail -s "Fileserver: CPU Warning" keithm107@bgab.de < /media/raid/data/myscripts/cpumsg.txt
echo "CPU Temperature is exceeding threshold – Shutting down in 5 sec ……."
sleep 5
shutdown -h now
else
echo "CPU Temperature still on the safe range "
echo "Core1: $t1°C"
echo "Core2: $t2°C"
fi

echo ''
echo "======================================="


#    echo '============================'                             >>/home/keith/Desktop/CoreWarning.Log
#    echo $(date)                                                    >>/home/keith/Desktop/CoreWarning.Log
#    echo ''                                                         >>/home/keith/Desktop/CoreWarning.Log
#    echo 'CPU Temperature still on the safe range'                  >>/home/keith/Desktop/CoreWarning.Log
#    echo "Core1: $t1°C"                                             >>/home/keith/Desktop/CoreWarning.Log
#    echo "Core2: $t2°C"                                             >>/home/keith/Desktop/CoreWarning.Log
#    echo ''                                                         >>/home/keith/Desktop/CoreWarning.Log
#    echo '============================'                             >>/home/keith/Desktop/CoreWarning.Log
