TOP_DIR:= $(shell cd $(PWD)/`dirname $(PARAM_FILE)`; pwd)

BOOT_DIR:=$(TOP_DIR)/uboot_nanopi2
KERNEL_DIR:=$(TOP_DIR)/linux-3.4.y
OUTPUT_DIR:=$(TOP_DIR)/output

BUILD_TOOLS_PATH:=$(TOP_DIR)/toolchain/arm-cortex_a8-linux-gnueabi-4.9.3/bin
CROSS_COMPILE:=arm-cortex_a8-linux-gnueabi-

ARCH=arm

MAKE_JOBS=4


.PHONY: usage
usage:
	@echo "build help"
	@echo "    make toolchain         -- unzip the cross compilation tool"
	@echo "    make all        	      -- build all, boot kernel rootfs"
	@echo "    make boot       	      -- build only boot"
	@echo "    make kernel     	      -- build only kernel"
	@echo "    make kernel_menuconfig -- build the kernel configuration "
	@echo "    make rootfs     	      -- build only rootfs project "
	@echo "    make install    	      -- install to target"
	@echo "    make boot_clean	      -- clean boot"
	@echo "    make kernel_clean      -- clean kernel"
	@echo "    make rootfs_clean      -- clean rootfs"
	@echo "    make clean_all          -- clean all, boot kernel rootfs"
	@echo 

.PHONY: toolchain all boot kernel kernel_menuconfig boot_image rootfs  install boot_clean kernel_clean rootfs_clean clean_all

all: boot kernel rootfs
clean_all: boot_clean kernel_clean rootfs_clean
install: boot_install kernel_install boot_image rootfs_install 

toolchain:
	@echo "~~~ decompres the cross compilation tool"
# tar -cvjf - arm-cortex_a8-linux-gnueabi-4.9.3 | split -b 10M - arm-cortex_a8-linux-gnueabi-4.9.3.tar.bz2
	@cd $(TOP_DIR)/toolchain; cat arm-cortex_a8-linux-gnueabi-4.9.3.tar.bz2* | sudo tar xvj -C ./;
	@echo "\n$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE)gcc -v"
	@$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE)gcc -v

boot:
	@echo "~~~ make boot"

ifeq ($(BOOT_DIR)/.config, $(wildcard $(BOOT_DIR)/.config))
	@cd $(BOOT_DIR); \
	make CROSS_COMPILE=${BUILD_TOOLS_PATH}/${CROSS_COMPILE} -j$(MAKE_JOBS);
endif

ifneq ($(BOOT_DIR)/.config, $(wildcard $(BOOT_DIR)/.config))
	@cd $(BOOT_DIR); \
	make s5p6818_nanopi3_config; \
	make CROSS_COMPILE=${BUILD_TOOLS_PATH}/${CROSS_COMPILE} -j$(MAKE_JOBS);
endif

	@echo "\nbuild boot done"

boot_clean:
	@cd $(BOOT_DIR); make distclean;

boot_install:
	install $(BOOT_DIR)/u-boot.bin $(OUTPUT_DIR)/

kernel:
	@echo "~~~ make kernel"

ifeq ($(KERNEL_DIR)/.config, $(wildcard $(KERNEL_DIR)/.config))
	@cd $(KERNEL_DIR); \
	make ARCH=${ARCH} CROSS_COMPILE=${BUILD_TOOLS_PATH}/${CROSS_COMPILE} -j$(MAKE_JOBS) uImage;
endif

ifneq ($(KERNEL_DIR)/.config, $(wildcard $(KERNEL_DIR)/.config))
	@echo "~~~ make ARCH=${ARCH} s5p6818_nanopi3_linux_wyk_defconfig"
	@cd $(KERNEL_DIR); \
	make ARCH=${ARCH} s5p6818_nanopi3_linux_wyk_defconfig; \
	make ARCH=${ARCH} CROSS_COMPILE=${BUILD_TOOLS_PATH}/${CROSS_COMPILE} -j$(MAKE_JOBS) uImage;
endif

	@echo "\nbuild kernel done"

kernel_clean:
	@cd $(KERNEL_DIR); make ARCH=$(ARCH) distclean;

kernel_install:
	install $(KERNEL_DIR)/arch/arm/boot/uImage $(OUTPUT_DIR)/boot/


kernel_menuconfig:
	@echo "~~~ make kernel menuconfig"
	@cd $(KERNEL_DIR); \
	make ARCH=$(ARCH) CROSS_COMPILE=${BUILD_TOOLS_PATH}/${CROSS_COMPILE} menuconfig;

boot_image:
	@echo "make_ext4fs -s -l 67108864 -a boot boot.img boot"
	@cd $(OUTPUT_DIR); \
	make_ext4fs -s -l 67108864 -a boot boot.img boot

rootfs:
	@echo "~~~ build rootfs"

rootfs_clean:
	@echo "~~~ rootfs clean"

rootfs_install:
	@echo "~~~ rootfs install"

