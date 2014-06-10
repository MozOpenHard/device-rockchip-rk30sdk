KERNEL_DEFCONFIG := rk30_hotdog_ti_defconfig

-include kernel/AndroidKernel.mk

ifeq ($(TARGET_PREBUILT_KERNEL),)
## kernel/AndroidKernel.mk should define TARGET_PREBUILT_KERNEL.
## If run to here, it means the kernel/AndroidKernel.mk does not
## exist, for some reason. If this is the case, uncomment below
## line and set TARGET_PREBUILT_KERNEL to a prebuilt kernel image.
# TARGET_PREBUILT_KERNEL := point_to_a_prebuilt_image
$(warning using prebuilt kernel: $(TARGET_PREBUILT_KERNEL))
endif

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)
