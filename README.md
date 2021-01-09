# NanoPC-T3

build kernel uImage:
cp arch/arm/configs/nanopi3_linux_config_wyk .config
make uImage

build uboot bin:
wyk@ubuntu:~/github/NanoPC-T3/uboot_nanopi2$ cd uboot_nanopi2/
wyk@ubuntu:~/github/NanoPC-T3/uboot_nanopi2$ ./build.sh 


create boot.img:
wyk@ubuntu:~/github/NanoPC-T3$ cd boot-img/
wyk@ubuntu:~/github/NanoPC-T3/boot-img$ ls
boot  build.sh
wyk@ubuntu:~/github/NanoPC-T3/boot-img$ ./build.sh 
shell pwd:/home/wyk/github/NanoPC-T3/boot-img
make uImage
make: Entering directory '/home/wyk/github/NanoPC-T3/linux-3.4.y'
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: 'include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready
  Image arch/arm/boot/uImage is ready
make: Leaving directory '/home/wyk/github/NanoPC-T3/linux-3.4.y'
rm /home/wyk/github/NanoPC-T3/boot-img/boot/uImage
rm: cannot remove '/home/wyk/github/NanoPC-T3/boot-img/boot/uImage': No such file or directory
cp /home/wyk/github/NanoPC-T3/boot-img/../linux-3.4.y/arch/arm/boot/uImage /home/wyk/github/NanoPC-T3/boot-img/boot/
make_ext4fs -s -l 67108864 -a boot /home/wyk/github/NanoPC-T3/boot-img/boot.img /home/wyk/github/NanoPC-T3/boot-img/boot
Creating filesystem with parameters:
    Size: 67108864
    Block size: 4096
    Blocks per group: 32768
    Inodes per group: 4096
    Inode size: 256
    Journal blocks: 1024
    Label: 
    Blocks: 16384
    Block groups: 1
    Reserved block group size: 7
Created filesystem with 18/4096 inodes and 3240/16384 blocks
wyk@ubuntu:~/github/NanoPC-T3/boot-img$ 


wyk@ubuntu:~/NanoPi/linux-3.4.y$ git remote -v
origin	https://github.com/friendlyarm/linux-3.4.y.git (fetch)
origin	https://github.com/friendlyarm/linux-3.4.y.git (push)
wyk@ubuntu:~/NanoPi/linux-3.4.y$ git branch -a
* nanopi2-lollipop-mr1
  remotes/origin/HEAD -> origin/nanopi2-lollipop-mr1
  remotes/origin/nanopi2-lollipop-mr1
  remotes/origin/s5p4418-nanopi2
wyk@ubuntu:~/NanoPi/linux-3.4.y$ 


wyk@ubuntu:~/NanoPi/uboot_nanopi2$ git remote -v
origin	https://github.com/friendlyarm/uboot_nanopi2.git (fetch)
origin	https://github.com/friendlyarm/uboot_nanopi2.git (push)
wyk@ubuntu:~/NanoPi/uboot_nanopi2$ git branch -a
* nanopi2-lollipop-mr1
  remotes/origin/HEAD -> origin/nanopi2-lollipop-mr1
  remotes/origin/nanopi2-lollipop-mr1
  remotes/origin/s5p4418-nanopi2
wyk@ubuntu:~/NanoPi/uboot_nanopi2$ 


