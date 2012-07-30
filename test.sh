#!/bin/bash
# Captures a series of images using gphoto2
# $1: Starting shutter speed (index: 16 = 1/100, 49 = 20s, ...
# $2: Ending shutter speed
# $3: Delay (in seconds) between exposures. There is a 14s overhead so take into account
# $4: Numer of exposures with starting shutter speed
# $5: Number of exposures with ending shutter speed
killall PTPCamera
j=0

for ((i=0; i<$4; i++))
do
gphoto2 --set-config-index /main/capturesettings/shutterspeed=$1
gphoto2 --capture-image-and-download
if [ $j -lt 10 ]
then
num=000$j
elif [ $j -lt 100 ]
then
num=00$j
elif [ $j -lt 1000 ]
then
num=0$j
fi
mv capt0000.jpg  gpcapt$num.jpg
j=$(($j + 1))
time=$(($3 - 14))
sleep $time
done

for ((i=$1; i<=$2; i++))
do
gphoto2 --set-config-index /main/capturesettings/shutterspeed=$i
gphoto2 --capture-image-and-download
if [ $j -lt 10 ]
then
num=000$j
elif [ $j -lt 100 ]
then
num=00$j
elif [ $j -lt 1000 ]
then
num=0$j
fi
mv capt0000.jpg  gpcapt$num.jpg
j=$(($j + 1))
time=$(($3 - 14))
sleep $time
done

for ((i=0; i<$5; i++))
do
gphoto2 --set-config-index /main/capturesettings/shutterspeed=$2
gphoto2 --capture-image-and-download
if [ $j -lt 10 ]
then
num=000$j
elif [ $j -lt 100 ]
then
num=00$j
elif [ $j -lt 1000 ]
then
num=0$j
fi
mv capt0000.jpg  gpcapt$num.jpg
j=$(($j + 1))
time=$(($3 - 14))
sleep $time
done
