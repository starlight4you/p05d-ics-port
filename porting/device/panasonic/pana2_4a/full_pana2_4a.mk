# Experimental AOSP android-4.0.4_r2.1 userspace bring-up. No boot image.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/panasonic/pana2_4a/device.mk)

PRODUCT_NAME := full_pana2_4a
PRODUCT_DEVICE := pana2_4a
PRODUCT_BRAND := docomo
PRODUCT_MODEL := P-05D
PRODUCT_MANUFACTURER := PANASONIC
