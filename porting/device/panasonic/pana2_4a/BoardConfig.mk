# Values from porting/evidence, with ICS panda as architecture reference only.
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_BOARD_PLATFORM := omap4
TARGET_BOOTLOADER_BOARD_NAME := pana2_4a

# Stock kernel cmdline (from /proc/cmdline on device, captured with root):
# viomem=* linux-timer=virtual vbd2=(3,3,1:179,21,rw) console=ttyO0 rootdelay=2
# init=/init mem=252M@0xB0000000 omap-vram=10M omapfb.vram=0:8M
# board-totoro-brb.modem_ipc=hsi vmalloc=256M user_debug=31 ccsecurity=on
# virtualized_IO_Android
# Kernel is stored as a Panasonic CertISW container in mmcblk0p8 (not boot.img).
# Userspace-only experiment: kernel image/container/offsets are not yet known.
# Do not substitute panda, Galaxy Nexus, P-04D or generic mkbootimg parameters.
TARGET_NO_KERNEL := true
TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true

TARGET_USERIMAGES_USE_EXT4 := true
# /proc/partitions reports KiB; these are partition capacities, not image proofs.
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 629145600
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1667760128

# First experiment uses AOSP framebuffer gralloc + software GLES.
# Stock GB SGX/overlay libraries are quarantined in porting/stock for ABI review.
BOARD_EGL_CFG := device/panasonic/pana2_4a/egl.cfg
USE_OPENGL_RENDERER := false
BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true
BOARD_HAVE_BLUETOOTH := false
