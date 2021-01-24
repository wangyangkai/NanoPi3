
BASE_DIR = $(shell pwd)
DIR = $(shell cd "$( dirname "$0"  )" && pwd )

export ARCH = arm

export KROOT = $(BASE_DIR)/../../linux-3.4.y
export CROSS_COMPILE = /opt/toolchain/arm-cortex_a8-linux-gnueabi-4.9.3/bin/arm-cortex_a8-linux-gnueabi-

export CC = $(CROSS_COMPILE)gcc

all:
	@echo "pwd:$(BASE_DIR)"
	@echo "pwd:$(DIR)"
	cd module && $(MAKE) all
	cd test_ioctl && $(MAKE) all

clean:
	$(MAKE) -C module clean
	$(MAKE) -C test_ioctl clean

install :
#	cp ./module/*.ko rootfs/drv_module
#	cp ./test_ioctl/test_ioclt rootfs/

