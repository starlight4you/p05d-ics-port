LOCAL_PATH := device/panasonic/pana2_4a

PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240

PRODUCT_PACKAGES += \
    gralloc.default \
    libGLES_android

# Reuse physical input mappings only. No GB core libraries are copied into ICS.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/input/omap-keypad.kl:system/usr/keylayout/omap-keypad.kl \
    $(LOCAL_PATH)/input/twl4030_pwrbutton.kl:system/usr/keylayout/twl4030_pwrbutton.kl \
    $(LOCAL_PATH)/input/touchsensor.kl:system/usr/keylayout/touchsensor.kl \
    $(LOCAL_PATH)/input/Atmel_maXTouch_Touchscreen.idc:system/usr/idc/Atmel_maXTouch_Touchscreen.idc \
    $(LOCAL_PATH)/init.pana2_4a.rc:root/init.pana2_4a.rc \
    $(LOCAL_PATH)/ueventd.pana2_4a.rc:root/ueventd.pana2_4a.rc \
    $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml

# Board ramdisk, USB initialization and vendor modules must be reconstructed
# from the actual stock boot image before testing a bootable build.
