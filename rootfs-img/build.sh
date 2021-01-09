#!/bin/sh
DIR="$( cd "$( dirname "$0"  )" && pwd  )"
echo "shell pwd:$DIR"

echo "rm $DIR/rootfs.img"
rm $DIR/rootfs.img

echo "cp $DIR/../buildroot/buildroot/output/target/* $DIR/rootfs/ -rf"
cp $DIR/../buildroot/buildroot/output/target/* $DIR/rootfs/ -rf

echo "make_ext4fs -s -l 448790528 $DIR/rootfs.img $DIR/rootfs"
make_ext4fs -s -l 448790528 $DIR/rootfs.img $DIR/rootfs
