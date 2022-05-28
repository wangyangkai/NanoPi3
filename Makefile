TOP_DIR:= $(shell cd $(PWD)/`dirname $(PARAM_FILE)`; pwd)

BOOT_DIR:=$(TOP_DIR)/uboot_nanopi2
KERNEL_DIR:=$(TOP_DIR)/linux-3.4.y
ROOTFS_DIR:=$(TOP_DIR)/buildroot/buildroot
OUTPUT_DIR:=$(TOP_DIR)/output

BUILD_TOOLS_PATH:=$(TOP_DIR)/toolchain/arm-cortex_a8-linux-gnueabi-4.9.3/bin
CROSS_COMPILE:=arm-cortex_a8-linux-gnueabi-

ARCH=arm

MAKE_JOBS=8


.PHONY: usage
usage:
	@echo "build help"
	@echo "make toolchain          -- unzip the cross compilation tool"
	@echo "make all                -- build all, bootloader kernel rootfs"
	@echo "make bootloader         -- build only bootloader"
	@echo "make kernel             -- build only kernel"
	@echo "make kernel_menuconfig  -- build the kernel configuration "
	@echo "make rootfs             -- build only rootfs project "
	@echo "make install            -- install to target"
	@echo "make bootloader_clean   -- clean bootloader"
	@echo "make kernel_clean       -- clean kernel"
	@echo "make rootfs_clean       -- clean rootfs"
	@echo "make clean_all          -- clean all, bootloader kernel rootfs"
	@echo 

.PHONY: toolchain all bootloader kernel kernel_menuconfig rootfs \
bootloader_install kernel_install boot_image rootfs_install rootfs_image \
install \
bootloader_clean kernel_clean rootfs_clean boot_image_clean rootfs_image_clean clean_all

all: bootloader kernel rootfs
install: bootloader_install kernel_install boot_image rootfs_install rootfs_image
clean_all: bootloader_clean kernel_clean rootfs_clean boot_image_clean rootfs_image_clean

toolchain:
	@echo "~~~ decompres the cross compilation tool"
# tar -cvjf - arm-cortex_a8-linux-gnueabi-4.9.3 | split -b 10M - arm-cortex_a8-linux-gnueabi-4.9.3.tar.bz2
	@cd $(TOP_DIR)/toolchain; cat arm-cortex_a8-linux-gnueabi-4.9.3.tar.bz2* | sudo tar xvj -C ./;
	@echo "\n$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE)gcc -v"
	@$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE)gcc -v


bootloader:
	@echo "~~~ make bootloader"

ifeq ($(BOOT_DIR)/.config, $(wildcard $(BOOT_DIR)/.config))
	@cd $(BOOT_DIR); \
	make CROSS_COMPILE=$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE) -j$(MAKE_JOBS);
endif

ifneq ($(BOOT_DIR)/.config, $(wildcard $(BOOT_DIR)/.config))
	@cd $(BOOT_DIR); \
	make s5p6818_nanopi3_config; \
	make CROSS_COMPILE=$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE) -j$(MAKE_JOBS);
endif

	@echo "\nbuild bootloader done"

bootloader_clean:
	@cd $(BOOT_DIR); make distclean;

bootloader_install:
	install $(BOOT_DIR)/u-boot.bin $(OUTPUT_DIR)/


kernel:
	@echo "~~~ make kernel"

ifeq ($(KERNEL_DIR)/.config, $(wildcard $(KERNEL_DIR)/.config))
	@cd $(KERNEL_DIR); \
	make ARCH=$(ARCH) CROSS_COMPILE=$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE) -j$(MAKE_JOBS) uImage;
endif

ifneq ($(KERNEL_DIR)/.config, $(wildcard $(KERNEL_DIR)/.config))
	@echo "~~~ make ARCH=$(ARCH) s5p6818_nanopi3_linux_wyk_defconfig"
	@cd $(KERNEL_DIR); \
	make ARCH=$(ARCH) s5p6818_nanopi3_linux_wyk_defconfig; \
	make ARCH=$(ARCH) CROSS_COMPILE=$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE) -j$(MAKE_JOBS) uImage;
endif

	@echo "\nbuild kernel done"

kernel_clean:
	@cd $(KERNEL_DIR); make ARCH=$(ARCH) distclean;

kernel_install:
	install $(KERNEL_DIR)/arch/arm/boot/uImage $(OUTPUT_DIR)/boot/


kernel_menuconfig:
	@echo "~~~ make kernel menuconfig"
	@cd $(KERNEL_DIR); \
	make ARCH=$(ARCH) CROSS_COMPILE=$(BUILD_TOOLS_PATH)/$(CROSS_COMPILE) menuconfig;

boot_image:
	@echo "make_ext4fs -s -l 67108864 -a boot boot.img boot"
	@cd $(OUTPUT_DIR); \
	make_ext4fs -s -l 67108864 -a boot boot.img boot;

boot_image_clean:
	@rm $(OUTPUT_DIR)/boot.img


rootfs:
	@echo "~~~ build rootfs"
	@echo "~~~ Fixme, check and configure toolchina path"
	@cd $(ROOTFS_DIR); \
	sed -i 's/BR2_TOOLCHAIN_EXTERNAL_PATH=\"\/opt\/toolchain\/arm-cortex_a8-linux-gnueabi-4.9.3\"/BR2_TOOLCHAIN_EXTERNAL_PATH=\"\/home\/wyk\/github\/NanoPC-T3\/toolchain\/arm-cortex_a8-linux-gnueabi-4.9.3\"/g' ./configs/s5p6818_nanopi3_wyk_defconfig;

ifeq ($(ROOTFS_DIR)/.config, $(wildcard $(ROOTFS_DIR)/.config))
	@cd $(ROOTFS_DIR); \
	make;
endif

ifneq ($(ROOTFS_DIR)/.config, $(wildcard $(ROOTFS_DIR)/.config))
	echo "make s5p6818_nanopi3_wyk_defconfig"
	@cd $(ROOTFS_DIR); \
	make s5p6818_nanopi3_wyk_defconfig; \
	make;
endif

rootfs_clean:
	@echo "~~~ rootfs clean"
	@cd $(ROOTFS_DIR); \
	make clean; \

rootfs_install:
	@echo "~~~ rootfs install"
ifneq ($(OUTPUT_DIR)/rootfs, $(wildcard $(OUTPUT_DIR)/rootfs))
	@mkdir $(OUTPUT_DIR)/rootfs
endif
	@cp $(ROOTFS_DIR)/output/target/* $(OUTPUT_DIR)/rootfs/ -rf

rootfs_image:
	@echo "make_ext4fs -s -l 448790528 rootfs.img $(OUTPUT_DIR)/rootfs"
	@cd $(OUTPUT_DIR); \
	make_ext4fs -s -l 448790528 rootfs.img rootfs;

rootfs_image_clean:
	@rm $(OUTPUT_DIR)/rootfs; \
	rm $(OUTPUT_DIR)/rootfs.img;
