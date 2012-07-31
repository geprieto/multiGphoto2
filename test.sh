#!/bin/bash
# Captures a series of images using gphoto2
# $1: Starting shutter speed (index: 16 = 1/100, 49 = 20s, ...
# $2: Ending shutter speed
# $3: Delay (in seconds) between exposures. There is a 14s overhead so take into account
# $4: Numer of exposures with starting shutter speed
# $5: Number of exposures with ending shutter speed

 # set this to how much does it take for gphoto to respond. This of course is also
 # the least amount of time between exposures
cpuoverhead=14
sleepingtime=$3

# this returns the exposure time based on the index from gphoto2. This is
# for a NIKON d5100, so you will have to edit this if you want to use it 
# for other cameras.
function exposure(){
case "$1" in
 0) speed=`echo 'scale=6;1/4000' | bc`
 echo $speed
 ;;
 1) speed=`echo 'scale=6;1/3200' | bc`
 echo $speed
 ;;
 2) speed=`echo 'scale=6;1/2500' | bc`
 echo $speed
 ;;
 3) speed=`echo 'scale=6;1/2000' | bc`
 echo $speed
 ;;
 4) speed=`echo 'scale=6;1/1600' | bc`
 echo $speed
 ;;
 5) speed=`echo 'scale=6;1/1250' | bc`
 echo $speed
 ;;
 6) speed=`echo 'scale=6;1/1000' | bc`
 echo $speed
 ;;
 7) speed=`echo 'scale=6;1/800' | bc`
 echo $speed
 ;;
 8) speed=`echo 'scale=6;1/640' | bc`
 echo $speed
 ;;
 9) speed=`echo 'scale=6;1/500' | bc`
 echo $speed
 ;;
 10) speed=`echo 'scale=6;1/400' | bc`
 echo $speed
 ;;
 11) speed=`echo 'scale=6;1/320' | bc`
 echo $speed
 ;;
 12) speed=`echo 'scale=6;1/250' | bc`
 echo $speed
 ;;
 13) speed=`echo 'scale=6;1/200' | bc`
 echo $speed
 ;;
 14) speed=`echo 'scale=6;1/160' | bc`
 echo $speed
 ;;
 15) speed=`echo 'scale=6;1/125' | bc`
 echo $speed
 ;;
 16) speed=`echo 'scale=6;1/100' | bc`
 echo $speed
 ;;
 17) speed=`echo 'scale=6;1/80' | bc`
 echo $speed
 ;;
 18) speed=`echo 'scale=6;1/60' | bc`
 echo $speed
 ;;
 19) speed=`echo 'scale=6;1/50' | bc`
 echo $speed
 ;;
 20) speed=`echo 'scale=6;1/40' | bc`
 echo $speed
 ;;
 21) speed=`echo 'scale=6;1/30' | bc`
 echo $speed
 ;;
 22) speed=`echo 'scale=6;1/25' | bc`
 echo $speed
 ;;
 23) speed=`echo 'scale=6;1/20' | bc`
 echo $speed
 ;;
 24) speed=`echo 'scale=6;1/15' | bc`
 echo $speed
 ;;
 25) speed=`echo 'scale=6;1/13' | bc`
 echo $speed
 ;;
 26) speed=`echo 'scale=6;1/10' | bc`
 echo $speed
 ;;
 27) speed=`echo 'scale=6;1/8' | bc`
 echo $speed
 ;;
 28) speed=`echo 'scale=6;1/6' | bc`
 echo $speed
 ;;
 29) speed=`echo 'scale=6;1/5' | bc`
 echo $speed
 ;;
 30) speed=`echo 'scale=6;1/4' | bc`
 echo $speed
 ;;
 31) speed=`echo 'scale=6;1/3' | bc`
 echo $speed
 ;;
 32) speed=`echo 'scale=6;10/25' | bc`
 echo $speed
 ;;
 33) speed=`echo 'scale=6;1/2' | bc`
 echo $speed
 ;;
 34) speed=`echo 'scale=6;10/16' | bc`
 echo $speed
 ;;
 35) speed=`echo 'scale=6;10/13' | bc`
 echo $speed
 ;;
 36) speed=1
 echo $speed
 ;;
 37) speed=`echo 'scale=6;13/10' | bc`
 echo $speed
 ;;
 38) speed=`echo 'scale=6;16/10' | bc`
 echo $speed
 ;;
 39) speed=2
 echo $speed
 ;;
 40) speed=`echo 'scale=6;25/10' | bc`
 echo $speed
 ;;
 41) speed=3
 echo $speed
 ;;
 42) speed=4
 echo $speed
 ;;
 43) speed=5
 echo $speed
 ;;
 44) speed=6
 echo $speed
 ;;
 45) speed=8
 echo $speed
 ;;
 46) speed=10
 echo $speed
 ;;
 47) speed=13
 echo $speed
 ;;
 48) speed=15
 echo $speed
 ;;
 49) speed=20
 echo $speed
 ;;
 50) speed=25
 echo $speed
 ;;
 51) speed=30
 echo $speed
 ;;
esac
}

function shutterspeed(){
exp=`exposure $1`
echo "Setting camera exposure to $exp s..."
gphoto2 --set-config-index /main/capturesettings/shutterspeed=$1
}

function expose(){
if [ $1 -lt 10 ]
then
num=000$1
elif [ $1 -lt 100 ]
then
num=00$1
elif [ $1 -lt 1000 ]
then
num=0$1
fi
echo "exposing and saving image locally into gpcapt$num.jpg..."
rm capt*.jpg
gphoto2 --capture-image-and-download
mv capt0000.jpg  gpcapt$num.jpg
}

time=$(($3 - $cpuoverhead))


# timing the experiment
totaltime=0

# initial exposures, without exposure change
for ((i=0; i<$4; i++))
do
exp=`exposure $1`
totaltime=`echo "scale=6;$totaltime+$exp+$sleepingtime" | bc`
done

initial=$totaltime
initialinh=`echo "scale=6;$totaltime/3600" | bc`
echo "For the initial exposures you have a total time of $totaltime seconds"
echo "That's $initialinh hours in this phase"

# exposures with change
if [ "$6" == 0 ];
then
startexp=$1
endexp=$2
else
startexp=$2
endexp=$1
fi
for ((i=$startexp; i<=$endexp; i++)) 
do
exp=`exposure $i`
totaltime=`echo "scale=6;$totaltime+$exp+$sleepingtime*4" | bc`
done

middle=`echo "scale=6;$totaltime-$initial" | bc`
middleinh=`echo "scale=6;$middle/3600" | bc`
echo "After the variable exposures are done $totaltime seconds have passed"
echo "That's $middleinh hours in this phase"

# final exposures
for ((i=0; i<$5; i++))
do
exp=`exposure $2`
totaltime=`echo "scale=6;$totaltime+$exp+$sleepingtime" | bc`
done

final=`echo "scale=6;$totaltime-$middle-$initial" | bc`
finalinh=`echo "scale=6;$final/3600" | bc`
echo "In total the experiment takes $totaltime seconds"
echo "That's $finalinh hours in this phase"

j=0
killall PTPCamera #so that the PTP OSX service doesn't conflict with the connection

# initial exposures, without exposure change
for ((i=0; i<$4; i++))
do
shutterspeed $1
expose $j
j=$(($j + 1))
sleep $time
done

# exposures with change
if [ "$6" == 0 ];
then
for ((i=$1; i<=$2; i++)) 
do
shutterspeed $i
expose $j
j=$(($j + 1))
sleep $time
expose $j
j=$(($j + 1))
sleep $time
done
else
for ((i=$1; i>=$2; i--)) 
do
shutterspeed $i
expose $j
j=$(($j + 1))
sleep $time
expose $j
j=$(($j + 1))
sleep $time
expose $j
j=$(($j + 1))
sleep $time
expose $j
j=$(($j + 1))
sleep $time
done
fi

# final exposures
for ((i=0; i<$5; i++))
do
shutterspeed $2
expose $j
j=$(($j + 1))
sleep $time
done
