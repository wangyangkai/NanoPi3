#!/bin/sh
DIR="$( cd "$( dirname "$0"  )" && pwd  )"

#SOURCE="$0"
#while [ -h "$SOURCE"  ]; do
# resolve $SOURCE until the file is no longer a symlink
#DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
#SOURCE="$(readlink "$SOURCE")"
#[[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
# if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#done

echo "shell pwd:$DIR"

echo "make uImage"
make -C $DIR/../linux-3.4.y uImage -j16

echo "rm $DIR/boot/uImage"
rm $DIR/boot/uImage

echo "cp $DIR/../linux-3.4.y/arch/arm/boot/uImage $DIR/boot/"
cp $DIR/../linux-3.4.y/arch/arm/boot/uImage $DIR/boot/

echo "make_ext4fs -s -l 67108864 -a boot $DIR/boot.img $DIR/boot"
#/home/wyk/NanoPi/android/Android5.1.2-060524/out/host/linux-x86/bin/make_ext4fs -s -l 67108864 -a boot /home/wyk/NanoPi/boot-img/boot.img /home/wyk/NanoPi/boot-img/boot
make_ext4fs -s -l 67108864 -a boot $DIR/boot.img $DIR/boot
