# Copyright (C) 2011 rockchip Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Everything in this directory will become public

ifeq ($(strip $(BOARD_WITH_CALL_FUNCTION)), true)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
endif

ifeq ($(strip $(BOARD_HAVE_BLUETOOTH)),true)
    include device/rockchip/rk30sdk/bluetooth/rk30_bt.mk
endif
include device/rockchip/rk30sdk/wifi/rk30_wifi.mk

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk
###########################################################
## Find all of the apk files under the named directories.
## Meant to be used like:
##    SRC_FILES := $(call all-apk-files-under,src tests)
###########################################################
define all-apk-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH)/$(1) ; \
          find ./ -maxdepth 1  -name "*.apk" -and -not -name ".*") \
 )
endef

########################################################
# Face lock
########################################################
ifeq ($(strip $(BUILD_WITH_FACELOCK)),true)
    # copy all model files
    define all-models-files-under
    $(patsubst ./%,%, \
      $(shell cd $(LOCAL_PATH)/$(1) ; \
              find ./ -type f -and -not -name "*.apk" -and -not -name "*.so" -and -not -name "*.mk") \
     )
    endef

    COPY_FILES := $(call all-models-files-under,facelock)
    PRODUCT_COPY_FILES += $(foreach files, $(COPY_FILES), \
        $(addprefix $(LOCAL_PATH)/facelock/, $(files)):$(addprefix system/, $(files)))

    PRODUCT_PACKAGES += \
        FaceLock

    PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/facelock/libfacelock_jni.so:system/lib/libfacelock_jni.so

    PRODUCT_PROPERTY_OVERRIDES += \
        ro.config.facelock = enable_facelock \
        persist.facelock.detect_cutoff=5000 \
        persist.facelock.recog_cutoff=5000
endif

########################################################
# Sdcard boot tool
########################################################
PRODUCT_COPY_FILES += $(LOCAL_PATH)/sdtool:root/sbin/sdtool
###########################################################
## Find all of the kl files under the named directories.
## Meant to be used like:
##    SRC_FILES := $(call all-kl-files-under,src tests)
###########################################################
define all-kl-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH); \
          find ./ -maxdepth 1  -name "*.kl")\
 )
endef
#########################################################
#  copy all the .kl file
#########################################################
COPY_KL_TARGET := $(call all-kl-files-under)

PRODUCT_COPY_FILES += $(foreach klName, $(COPY_KL_TARGET), \
	$(addprefix $(LOCAL_PATH)/, $(klName)):$(addprefix system/usr/keylayout/, $(klName)))

PRODUCT_COPY_FILES += \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/bin/busybox:system/bin/busybox \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/bin/io:system/xbin/io \
        device/rockchip/$(TARGET_PRODUCT)/init.rc:root/init.rc \
        device/rockchip/$(TARGET_PRODUCT)/mkdosfs:root/sbin/mkdosfs \
        device/rockchip/$(TARGET_PRODUCT)/init.$(TARGET_BOARD_HARDWARE).rc:root/init.$(TARGET_BOARD_HARDWARE).rc \
        device/rockchip/$(TARGET_PRODUCT)/init.$(TARGET_BOARD_HARDWARE).usb.rc:root/init.$(TARGET_BOARD_HARDWARE).usb.rc \
        device/rockchip/$(TARGET_PRODUCT)/ueventd.$(TARGET_BOARD_HARDWARE).rc:root/ueventd.$(TARGET_BOARD_HARDWARE).rc \
        device/rockchip/$(TARGET_PRODUCT)/media_profiles.xml:system/etc/media_profiles.xml \
        device/rockchip/$(TARGET_PRODUCT)/alarm_filter.xml:system/etc/alarm_filter.xml \
	device/rockchip/$(TARGET_PRODUCT)/rk29-keypad.kl:system/usr/keylayout/rk29-keypad.kl

# Bluetooth configuration files
PRODUCT_COPY_FILES += \
	system/bluetooth/data/main.nonsmartphone.le.conf:system/etc/bluetooth/main.conf \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	$(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf

PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/rk30xxnand_ko.ko.3.0.36+:root/rk30xxnand_ko.ko.3.0.36+ \
        device/rockchip/$(TARGET_PRODUCT)/rk30xxnand_ko.ko.3.0.8+:root/rk30xxnand_ko.ko.3.0.8+ 

PRODUCT_COPY_FILES += \
       device/rockchip/$(TARGET_PRODUCT)/vold.fstab:system/etc/vold.fstab 

# For audio-recoard 
PRODUCT_PACKAGES += \
    libsrec_jni

ifeq ($(TARGET_BOARD_PLATFORM),rk30xx)
    # GPU-MALI
    PRODUCT_PACKAGES += \
        libEGL_mali.so \
        libGLESv1_CM_mali.so \
        libGLESv2_mali.so \
        libMali.so \
        libUMP.so \
        mali.ko \
        ump.ko 
PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libMali.so:system/lib/libMali.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libMali.so:obj/lib/libMali.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libUMP.so:system/lib/libUMP.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libUMP.so:obj/lib/libUMP.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libEGL_mali.so:system/lib/egl/libEGL_mali.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libGLESv1_CM_mali.so:system/lib/egl/libGLESv1_CM_mali.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/libGLESv2_mali.so:system/lib/egl/libGLESv2_mali.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/mali.ko.3.0.36+:system/lib/modules/mali.ko.3.0.36+ \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/mali.ko:system/lib/modules/mali.ko \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/ump.ko.3.0.36+:system/lib/modules/ump.ko.3.0.36+ \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libmali/ump.ko:system/lib/modules/ump.ko \
        device/rockchip/$(TARGET_PRODUCT)/gpu_performance/performance_info.xml:system/etc/performance_info.xml \
        device/rockchip/$(TARGET_PRODUCT)/gpu_performance/performance:system/bin/performance \
        device/rockchip/$(TARGET_PRODUCT)/gpu_performance/libperformance_runtime.so:system/lib/libperformance_runtime.so \
        device/rockchip/$(TARGET_PRODUCT)/gpu_performance/gpu.$(TARGET_BOARD_HARDWARE).so:system/lib/hw/gpu.$(TARGET_BOARD_HARDWARE).so
else

#SGX540       
PRODUCT_COPY_FILES += \
				device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/pvrsrvctl:/system/vendor/bin/pvrsrvctl\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/gralloc.rk30xxb.so:system/vendor/lib/hw/gralloc.rk30xxb.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libEGL_POWERVR_SGX540_130.so:system/vendor/lib/egl/libEGL_POWERVR_SGX540_130.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libGLESv1_CM_POWERVR_SGX540_130.so:system/vendor/lib/egl/libGLESv1_CM_POWERVR_SGX540_130.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libGLESv2_POWERVR_SGX540_130.so:system/vendor/lib/egl/libGLESv2_POWERVR_SGX540_130.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libIMGegl.so:system/vendor/lib/libIMGegl.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libPVRScopeServices.so:system/vendor/lib/libPVRScopeServices.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libglslcompiler.so:system/vendor/lib/libglslcompiler.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libpvr2d.so:system/vendor/lib/libpvr2d.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libpvrANDROID_WSEGL.so:system/vendor/lib/libpvrANDROID_WSEGL.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libsrv_init.so:system/vendor/lib/libsrv_init.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libsrv_um.so:system/vendor/lib/libsrv_um.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libusc.so:system/vendor/lib/libusc.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/rklfb.ko:system/lib/modules/rklfb.ko\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/pvrsrvkm.ko:system/lib/modules/pvrsrvkm.ko\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/libperformance_runtime.so:system/lib/libperformance_runtime.so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/gpu.$(TARGET_BOARD_HARDWARE).so:system/lib/hw/gpu.$(TARGET_BOARD_HARDWARE).so\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libpvr/performance_info.xml:system/etc/performance_info.xml
endif

PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libipp/rk29-ipp.ko.3.0.36+:system/lib/modules/rk29-ipp.ko.3.0.36+ \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libipp/rk29-ipp.ko:system/lib/modules/rk29-ipp.ko

PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libion/libion.so:system/lib/libion.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libion/libion.so:obj/lib/libion.so 

PRODUCT_COPY_FILES += \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/bin/io:system/xbin/io \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/bin/busybox:root/sbin/busybox
	
#########################################################
#       adblock rule
#########################################################        
PRODUCT_COPY_FILES += \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/etc/.allBlock:system/etc/.allBlock \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/etc/.videoBlock:system/etc/.videoBlock 

#########################################################
#       webkit
#########################################################        
PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libwebkit/libwebcore.so:system/lib/libwebcore.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libwebkit/libwebcore.so:obj/lib/libwebcore.so \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libwebkit/webkit_ver:system/lib/webkit_ver

#########################################################
#       vpu lib
#########################################################        
sf_lib_files := $(shell ls $(LOCAL_PATH)/proprietary/libvpu | grep .so)
PRODUCT_COPY_FILES += \
        $(foreach file, $(sf_lib_files), $(LOCAL_PATH)/proprietary/libvpu/$(file):system/lib/$(file))

PRODUCT_COPY_FILES += \
        $(foreach file, $(sf_lib_files), $(LOCAL_PATH)/proprietary/libvpu/$(file):obj/lib/$(file))

PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/media_codecs.xml:system/etc/media_codecs.xml \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/registry:system/lib/registry \
	device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/wfd:system/bin/wfd \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/vpu_service.ko.3.0.36+:system/lib/modules/vpu_service.ko.3.0.36+ \
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/vpu_service.ko:system/lib/modules/vpu_service.ko\
        device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/rk30_mirroring.ko.3.0.8+:system/lib/modules/rk30_mirroring.ko.3.0.8+\
	device/rockchip/$(TARGET_PRODUCT)/proprietary/libvpu/rk30_mirroring.ko.3.0.36+:system/lib/modules/rk30_mirroring.ko.3.0.36+

PRODUCT_PACKAGES += \
    ilibapedec.so \
    libjesancache.so \
    libjpeghwdec.so \
    libjpeghwenc.so \
    libOMX_Core.so \
    libomxvpu.so \
    librkswscale.so \
    librkwmapro.so \
    libyuvtorgb \
    libvpu.so \
    libhtml5_check.so

ifeq ($(strip $(BUILD_WITH_RK_EBOOK)),true)
    PRODUCT_PACKAGES += \
        BooksProvider \
        RKEBookReader
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/rkbook/bin/adobedevchk:system/bin/adobedevchk \
        $(LOCAL_PATH)/rkbook/lib/libadobe_rmsdk.so:system/lib/libadobe_rmsdk.so \
        $(LOCAL_PATH)/rkbook/lib/libRkDeflatingDecompressor.so:system/lib/libRkDeflatingDecompressor.so \
        $(LOCAL_PATH)/rkbook/lib/librm_ssl.so:system/lib/librm_ssl.so \
        $(LOCAL_PATH)/rkbook/lib/libflip.so:system/lib/libflip.so \
        $(LOCAL_PATH)/rkbook/lib/librm_crypto.so:system/lib/librm_crypto.so \
        $(LOCAL_PATH)/rkbook/lib/rmsdk.ver:system/lib/rmsdk.ver \
        $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeMyungjoStd.bin:system/fonts/adobefonts/AdobeMyungjoStd.bin \
        $(LOCAL_PATH)/rkbook/fonts/adobefonts/CRengine.ttf:system/fonts/adobefonts/CRengine.ttf \
        $(LOCAL_PATH)/rkbook/fonts/adobefonts/RyoGothicPlusN.bin:system/fonts/adobefonts/RyoGothicPlusN.bin \
        $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeHeitiStd.bin:system/fonts/adobefonts/AdobeHeitiStd.bin \
        $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeMingStd.bin:system/fonts/adobefonts/AdobeMingStd.bin
endif

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    NoiseField \
    PhaseBeam \
    librs_jni \
    libjni_pinyinime \
    hostapd_rtl

# HAL
PRODUCT_PACKAGES += \
    power.$(TARGET_BOARD_PLATFORM) \
    sensors.$(TARGET_BOARD_HARDWARE) \
    gralloc.$(TARGET_BOARD_HARDWARE) \
    hwcomposer.$(TARGET_BOARD_HARDWARE) \
    lights.$(TARGET_BOARD_HARDWARE) \
    camera.$(TARGET_BOARD_HARDWARE) \
    Camera \
    akmd8975 

# charge
PRODUCT_PACKAGES += \
    charger \
    charger_res_images 

# drmservice
PRODUCT_PACKAGES += \
    drmservice

PRODUCT_CHARACTERISTICS := tablet

# audio lib
PRODUCT_PACKAGES += \
    audio_policy.$(TARGET_BOARD_HARDWARE) \
    audio.primary.$(TARGET_BOARD_HARDWARE) \
    audio.a2dp.default\
    audio.r_submix.default

# Filesystem management tools
# EXT3/4 support
PRODUCT_PACKAGES += \
    mke2fs \
    e2fsck \
    tune2fs \
    resize2fs \
    mkdosfs
# audio lib
ifeq ($(strip $(BOARD_USES_ALSA_AUDIO)),true)
PRODUCT_PACKAGES += \
    libasound \
    alsa.default \
    acoustics.default

######################################
# 	phonepad codec list
######################################
ifeq ($(strip $(BOARD_CODEC_WM8994)),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/codec/asound_phonepad_wm8994.conf:system/etc/asound.conf
endif

ifeq ($(strip $(BOARD_CODEC_RT5625_SPK_FROM_SPKOUT)),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/codec/asound_phonepad_rt5625.conf:system/etc/asound.conf
endif

ifeq ($(strip $(BOARD_CODEC_RT5625_SPK_FROM_HPOUT)),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/codec/asound_phonepad_rt5625_spk_from_hpout.conf:system/etc/asound.conf
endif

ifeq ($(strip $(BOARD_CODEC_RT3261)),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/codec/asound_phonepad_rt3261.conf:system/etc/asound.conf
endif

ifeq ($(strip $(BOARD_CODEC_ITV)),true)
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/asound_itv.conf:system/etc/asound.conf
endif

$(call inherit-product-if-exists, external/alsa-lib/copy.mk)

ifeq ($(strip $(BUILD_WITH_ALSA_UTILS)),true)
    $(call inherit-product-if-exists, external/alsa-utils/copy.mk)
endif

endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=adb \
    persist.sys.strictmode.visual=false \
    dalvik.vm.jniopts=warnonly \
    ro.rksdk.version=RK30_ANDROID$(PLATFORM_VERSION)-SDK-v1.00.00 \
    sys.hwc.compose_policy=0 \
    sys.dts_ac3.shield=0	\
    sys.browser.use.overlay=0   \
    sf.power.control=2073600 \
    ro.sf.fakerotation=true \
    ro.sf.hwrotation=270 \
    ro.rk.MassStorage=false \
    wifi.interface=wlan0 \
    ro.tether.denied=false \
    ro.sf.lcd_density=160 \
    ro.rk.screenoff_time=-1 \
    ro.rk.def_brightness=200\
    ro.rk.homepage_base=http://www.google.com/webhp?client={CID}&amp;source=android-home\
    ro.rk.install_non_market_apps=false\
    ro.default.size=100\
    persist.sys.timezone=Atlantic/Azores\
    ro.product.usbfactory=rockchip_usb \
    wifi.supplicant_scan_interval=15 \
    ro.opengles.version=131072 \
    testing.mediascanner.skiplist = /mnt/sdcard/Android/ \
    ro.factory.tool=0 \
    ro.kernel.android.checkjni=0


ifeq ($(strip $(BOARD_HAVE_BLUETOOTH)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.bt_enable=true
else
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.bt_enable=false
endif

ifeq ($(strip $(MT6622_BT_SUPPORT)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.btchip=mt6622
endif

ifeq ($(strip $(BLUETOOTH_USE_BPLUS)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.btchip=broadcom.bplus
endif

ifeq ($(strip $(MT7601U_WIFI_SUPPORT)),true)
    PRODUCT_PROPERTY_OVERRIDES += ro.rk.wifichip=mt7601u
endif

PRODUCT_TAGS += dalvik.gc.type-precise

# NTFS support
PRODUCT_PACKAGES += \
    ntfs-3g

PRODUCT_PACKAGES += \
        com.android.future.usb.accessory

PRODUCT_PACKAGES += \
        librecovery_ui_$(TARGET_PRODUCT)

#for bt
PRODUCT_PACKAGES += \
        bt_vendor.conf

# for bugreport
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += device/rockchip/$(TARGET_PRODUCT)/bugreport.sh:system/bin/bugreport.sh
endif

# wifi
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

#########################################################
#	Phone
#########################################################
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/etc/ppp/ip-down:system/etc/ppp/ip-down \
    $(LOCAL_PATH)/phone/etc/ppp/ip-up:system/etc/ppp/ip-up \
    $(LOCAL_PATH)/phone/etc/ppp/call-pppd:system/etc/ppp/call-pppd \
    $(LOCAL_PATH)/phone/etc/operator_table:system/etc/operator_table 

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/phone/bin/usb_modeswitch.sh:system/bin/usb_modeswitch.sh \
    $(LOCAL_PATH)/phone/bin/usb_modeswitch:system/bin/usb_modeswitch \
    $(LOCAL_PATH)/phone/lib/libril-rk29-dataonly.so:system/lib/libril-rk29-dataonly.so

modeswitch_files := $(shell ls $(LOCAL_PATH)/phone/etc/usb_modeswitch.d)
PRODUCT_COPY_FILES += \
    $(foreach file, $(modeswitch_files), \
    $(LOCAL_PATH)/phone/etc/usb_modeswitch.d/$(file):system/etc/usb_modeswitch.d/$(file))

PRODUCT_PACKAGES += \
    rild \
    chat

ifeq ($(strip $(BOARD_WITH_CALL_FUNCTION)), true)
    PRODUCT_PACKAGES += Mms
endif

######################################
# 	phonepad modem list
######################################
ifeq ($(strip $(BOARD_RADIO_MU509)), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ril.function.dataonly=0 
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-mu509.so
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.atchannel=/dev/ttyS1
    ADDITIONAL_DEFAULT_PROPERTIES += ril.pppchannel=/dev/ttyUSB244
    ADDITIONAL_DEFAULT_PROPERTIES += ril.microphone=2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.loudspeaker=5
    ADDITIONAL_DEFAULT_PROPERTIES += ril.switch.sound.path=0

    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/lib/libreference-ril-mu509.so:system/lib/libreference-ril-mu509.so
endif

ifeq ($(strip $(BOARD_RADIO_MW100)), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ril.function.dataonly=0
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-mw100.so
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.atchannel=/dev/ttyUSB246
    ADDITIONAL_DEFAULT_PROPERTIES += ril.pppchannel=/dev/ttyUSB247
    ADDITIONAL_DEFAULT_PROPERTIES += ril.headset=4
    ADDITIONAL_DEFAULT_PROPERTIES += ril.switch.sound.path=3

    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/lib/libreference-ril-mw100.so:system/lib/libreference-ril-mw100.so
endif

ifeq ($(strip $(BOARD_RADIO_MT6229)), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ril.function.dataonly=0
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-mt6229.so
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.atchannel=/dev/ttyUSB244
    ADDITIONAL_DEFAULT_PROPERTIES += ril.pppchannel=/dev/ttyACM0
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/lib/libreference-ril-mt6229.so:system/lib/libreference-ril-mt6229.so
endif

ifeq ($(strip $(BOARD_RADIO_SEW868)), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ril.function.dataonly=0
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-sew868.so
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.atchannel=/dev/ttyUSBS244
    ADDITIONAL_DEFAULT_PROPERTIES += ril.pppchannel=/dev/ttyUSB247
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/lib/libreference-ril-sew868.so:system/lib/libreference-ril-sew868.so
endif

ifeq ($(strip $(BOARD_RADIO_MI700)), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ril.function.dataonly=0 
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-MI700.so
    ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.atchannel=/dev/ttyUSB1
    ADDITIONAL_DEFAULT_PROPERTIES += ril.pppchannel=/dev/ttyUSB3
    ADDITIONAL_DEFAULT_PROPERTIES += ril.microphone=2
    ADDITIONAL_DEFAULT_PROPERTIES += ril.loudspeaker=5
    ADDITIONAL_DEFAULT_PROPERTIES += ril.switch.sound.path=0

    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/lib/libreference-ril-MI700.so:system/lib/libreference-ril-MI700.so
endif

ifeq ($(strip $(BOARD_RADIO_DATAONLY)), true)
    #Use external 3G dongle
    PRODUCT_PROPERTY_OVERRIDES += \
        rild.libargs=-d_/dev/ttyUSB1 \
        ril.pppchannel=/dev/ttyUSB2 \
        rild.libpath=/system/lib/libril-rk29-dataonly.so \
        ril.function.dataonly=1
endif

# hardware cursor
PRODUCT_PROPERTY_OVERRIDES += \
        cursor.sw=true \
        cursor.hw=false \
        cursor.hw.colour.red = 0 \
        cursor.hw.colour.green = 255 \
        cursor.hw.colour.blue = 0

# vpu render video mode
PRODUCT_PROPERTY_OVERRIDES += \
		video.use.overlay=0

# Get the long list of APNs 
PRODUCT_COPY_FILES += device/rockchip/$(TARGET_PRODUCT)/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml

ifeq ($(strip $(BOARD_BOOT_READAHEAD)),true)
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/proprietary/readahead/readahead:root/sbin/readahead \
        $(LOCAL_PATH)/proprietary/readahead/readahead_list.txt:root/readahead_list.txt
endif

#whtest for bin
PRODUCT_COPY_FILES += \
        device/rockchip/$(TARGET_PRODUCT)/whtest.sh:system/bin/whtest.sh

$(call inherit-product, external/wlan_loader/wifi-firmware.mk)
#$(call inherit-product, $(LOCAL_PATH)/bluetooth/firmware/bt-firmware.mk)

#BT_FIRMWARE_FILES := $(shell ls $(LOCAL_PATH)/bluetooth/firmware)
#PRODUCT_COPY_FILES += \
#    $(foreach file, $(BT_FIRMWARE_FILES), $(LOCAL_PATH)/bluetooth/firmware/$(file):system/vendor/firmware/$(file))

PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/settings_disabled_menu_list.xml:system/etc/permissions/settings_disabled_menu_list.xml

PRODUCT_PROPERTY_OVERRIDES += \
        ro.vendor.sw.version=$(VENDOR_SOFTWARE_VERSION)
$(call inherit-product, device/rockchip/rk30_common/common.mk)
PRODUCT_PACKAGES += hwcomposer.rk30board.so gralloc.rk30board.so libyuvtorgb.so audio.primary.rk30board.so audio_policy.rk30board.so alsa.default.so acoustics.default.so
