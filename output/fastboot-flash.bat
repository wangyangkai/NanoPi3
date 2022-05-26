fastboot flash boot %~dp0\boot.img
fastboot flash bootloader %~dp0\u-boot.bin
fastboot flash cache rootfs.img

::bootloader
::set bootargs console=ttyAMA0,115200n8 root=/dev/mmcblk0p3 init=/linuxrc
::save

pause
fastboot reboot