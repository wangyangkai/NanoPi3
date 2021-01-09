#!/bin/sh
make clean
make s5p6818_nanopi3_config
make CROSS_COMPILE=/opt/toolchain/arm-cortex_a9-eabi-4.7-eglibc-2.18/bin/arm-cortex_a9-linux-gnueabi- -j4
