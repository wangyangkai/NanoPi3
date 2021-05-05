#!/bin/sh
#cp arch/arm/configs/s5p6818_nanopi3_linux_wyk_config .config
make ARCH=arm CROSS_COMPILE=/opt/toolchain/arm-cortex_a8-linux-gnueabi-4.9.3/bin/arm-cortex_a8-linux-gnueabi- uImage -j16
