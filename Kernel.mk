#if use probuilt kernel or build kernel from source code
-include device/hardkernel/common/gpu.mk

INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel
INSTALLED_RTCKERNEL_TARGET := $(PRODUCT_OUT)/system/etc/Image

KERNEL_ARCH := arm64
KERNEL_DEVICETREE := meson64_odroidc2
KERNEL_DEFCONFIG := odroidc2_defconfig
RTCKERNEL_DEFCONFIG := odroidc2_rtc_defconfig

KERNEL_ROOTDIR := kernel
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
RTCKERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/RTCKERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
RTCKERNEL_CONFIG := $(RTCKERNEL_OUT)/.config
KERNEL_IMAGE := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image.lzo
RTCKERNEL_IMAGE := $(RTCKERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image
KERNEL_MODULES_INSTALL := system
KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
BOARD_MKBOOTIMG_ARGS := --second $(PRODUCT_OUT)/$(KERNEL_DEVICETREE).dtb

PREFIX_CROSS_COMPILE=aarch64-linux-gnu-

define cp-modules
	mkdir -p $(PRODUCT_OUT)/root/boot

	cp $(MALI_OUT)/mali/mali.ko $(PRODUCT_OUT)/root/boot
	cp $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/
endef

define mv-modules
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
	if [ "$$mdpath" != "" ]; then \
	mpath=`dirname $$mdpath`;\
	ko=`find $$mpath/kernel $$mpath/hardware -type f -name *.ko`;\
	for i in $$ko; do echo $$i; mv $$i $(KERNEL_MODULES_OUT)/; done;\
	fi;\
	ko=`find hardware/backports -type f -name *.ko`;\
	mkdir -p $(KERNEL_MODULES_OUT)/backports; \
	for i in $$ko; do echo $$i; mv $$i $(KERNEL_MODULES_OUT)/backports/; done;
endef

define clean-module-folder
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
       if [ "$$mdpath" != "" ];then\
       mpath=`dirname $$mdpath`; rm -rf $$mpath;\
       fi
endef

define btusb-modules
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/vendor/broadcom/btusb/csr8510/ ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/vendor/broadcom/btusb/csr8510/btusb.ko $(TARGET_OUT)/lib/modules/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)
	mkdir -p $(RTCKERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(RTCKERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(RTCKERNEL_DEFCONFIG)

$(KERNEL_IMAGE): $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) \
		INSTALL_MOD_PATH=../../$(KERNEL_MODULES_INSTALL) INSTALL_MOD_STRIP=1 \
		modules_install
	$(MAKE) -C hardware/backports O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) KLIB_BUILD=../../$(KERNEL_OUT) \
		defconfig-odroidc
	$(MAKE) -C hardware/backports O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) KLIB_BUILD=../../$(KERNEL_OUT)
	$(gpu-modules)
	$(cp-modules)
	$(mv-modules)
	$(btusb-modules)
	$(clean-module-folder)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(RTCKERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE)
	cp $(RTCKERNEL_IMAGE) $(INSTALLED_RTCKERNEL_TARGET)

.PHONY: kernelconfig
kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(RTCKERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig

.PHONY: savekernelconfig
savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig
	@echo
	@echo Saved to $(KERNEL_OUT)/defconfig
	@echo
	@echo handly merge to "$(KERNEL_ROOTDIR)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)" if need
	@echo
	env KCONFIG_NOTIMESTAMP=true \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(RTCKERNEL_OUT) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig


$(INSTALLED_KERNEL_TARGET): $(KERNEL_IMAGE) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)
