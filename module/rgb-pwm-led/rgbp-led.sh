#!/bin/sh

function rand(){  
	min=$1  
	max=$(($2-$min+1))  
	num=$(($RANDOM+1000000000))
	echo $(($num%$max+$min))  
}

for i in $(seq 1 1000000)
do
#echo $i
rnd_r=$(rand 1 255)
echo $rnd_r > /sys/class/leds/ledpR/brightness
rnd_g=$(rand 0 255)
echo $rnd_g > /sys/class/leds/ledpG/brightness
rnd_b=$(rand 0 255)
echo $rnd_b > /sys/class/leds/ledpB/brightness
#echo $rnd_r $rnd_g $rnd_b
#usleep 1000
done
