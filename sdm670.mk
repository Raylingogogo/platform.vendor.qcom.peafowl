# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
  dalvik.vm.heapgrowthlimit=256m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := sdm670
PRODUCT_DEVICE := sdm670
PRODUCT_BRAND := Android
PRODUCT_MODEL := SDM670 for arm64

#Initial bringup flags
TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false
BOARD_HAVE_QCOM_FM := true

DEVICE_PACKAGE_OVERLAYS += device/qcom/sdm670/overlay

# Default A/B configuration.
ENABLE_AB ?= true

TARGET_KERNEL_VERSION := 4.9

TARGET_USES_NQ_NFC := true

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

-include $(QCPATH)/common/config/qtic-config.mk

# Video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/sdm670/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/sdm670/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext

ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

TARGET_DISABLE_DASH := true

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

ifneq ($(strip $(QCPATH)),)
    PRODUCT_BOOT_JARS += WfdCommon
endif

# Video platform properties file
PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/sdm845/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/sdm670/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

PRODUCT_COPY_FILES += device/qcom/sdm670/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
PRODUCT_COPY_FILES += device/qcom/sdm670/media_codecs_sdm670_v0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_sdm670_v0.xml

PRODUCT_COPY_FILES += device/qcom/sdm670/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
PRODUCT_COPY_FILES += device/qcom/sdm670/media_codecs_performance_sdm670_v0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance_sdm670_v0.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/sdm670/sdm670.mk

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    bootctrl.sdm670 \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

#Healthd packages
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-convert \
    android.hardware.health@1.0-service \
    libhealthd.msm

DEVICE_MANIFEST_FILE := device/qcom/sdm670/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/sdm670/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# MIDI feature 124
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/sdm670/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

# Enable binderized USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# WLAN host driver
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/qcom/sdm670/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/sdm670/wifi_concurrency_cfg.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wifi_concurrency_cfg.txt

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#for wlan
PRODUCT_PACKAGES += \
    wificond \
    wifilogd

# Sensor conf files
PRODUCT_COPY_FILES += \
    device/qcom/sdm670/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml

#Enable debug libraries
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_PACKAGES += libstagefright_debug \
                    libmediaplayerservice_debug
endif

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Enable full treble flag

#Add soft home, back and multitask keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
    ro.opengles.version=196610

#system prop for bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=cherokee

PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/vendor/lib64/libril-qc-hal-qmi.so

#Set property to enable zRam
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.qti.config.zram=true

#Property to set BG App limit
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.qti.sys.fw.bg_apps_limit=60

#Property for enabling learning module
PRODUCT_PROPERTY_OVERRIDES += debug.vendor.qti.enable.lm=1

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
KMGK_USE_QTI_SERVICE := true

# dm-verity definitions
ifneq ($(BOARD_AVB_ENABLE), true)
    PRODUCT_SUPPORTS_VERITY := true
endif

#Enable DuerOS for voiceUI
BOARD_VOICEUI_USE_DUEROS := true

#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service
