#!/bin/sh
make clean
make s5p6818_nanopi3_config
make CROSS_COMPILE=/opt/toolchain/arm-cortex_a8-linux-gnueabi-4.9.3/bin/arm-cortex_a8-linux-gnueabi- -j4
