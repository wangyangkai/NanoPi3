#!/bin/sh

APP="./test_ioctl"

for i in $(seq 1 10000)
do
echo $i
$APP /dev/led-0 1 0
usleep 500000
$APP /dev/led-0 0 0
$APP /dev/led-1 1 0
usleep 500000
$APP /dev/led-1 0 0
$APP /dev/led-2 1 0
usleep 500000
$APP /dev/led-2 0 0
$APP /dev/led-1 1 0
usleep 500000
$APP /dev/led-1 0 0
done
