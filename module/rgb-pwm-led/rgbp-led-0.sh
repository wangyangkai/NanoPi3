#!/bin/sh

#rgb rbg brg bgr grb gbr

for n in $(seq 1 6)
do
#echo $n

for i in $(seq 0 255)
do
	for j in $(seq 0 255)
	do
		for k in $(seq 0 255)
		do
			if [ $n = 1 ];then
				echo $i > /sys/class/leds/ledpR/brightness
				echo $j > /sys/class/leds/ledpG/brightness
				echo $k > /sys/class/leds/ledpB/brightness
				#echo $i $j $k
			fi
			#usleep 100000
		done

	done

done

done
