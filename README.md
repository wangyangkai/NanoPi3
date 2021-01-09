# NanoPC-T3

build kernel uImage:
cp arch/arm/configs/nanopi3_linux_config_wyk .config
make uImage


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


