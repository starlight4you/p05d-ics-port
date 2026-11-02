# P-05D / pana2_4a ICS userspace experiment

Target: AOSP `android-4.0.4_r2.1`. This is an **unbuilt device-tree starting point**,
not a working ROM. No boot, recovery, OTA packaging or flashing procedure exists.

Copy this directory to `device/panasonic/pana2_4a` in a matching AOSP checkout.
Then `source build/envsetup.sh`, `lunch full_pana2_4a-eng`, `make systemimage`.
These commands are the proposed build path, not verified build instructions.
Use a compatible historical Linux x86 build environment; this host is macOS ARM64.

The first experiment uses generic audio, a camera stub, framebuffer gralloc and
software GLES. It intentionally does not install the Gingerbread graphics, camera,
audio, radio or Wi-Fi stack. The phone functionality is not implemented.

Stock init scripts are now captured via root (`/system/xbin/su`) and copied into
this device tree as `init.pana2_4a.rc` and `ueventd.pana2_4a.rc`; the kernel
partition is captured as a CertISW container. These are starting inputs, not
verified ICS-compatible scripts: services and module paths still need review
against ICS userspace. An ICS system image alone remains insufficient to boot.

Before a real boot test, obtain and inspect the original kernel/ramdisk/container,
resolve vendor USB/module initialization, verify ICS kernel interfaces, and establish
a recoverable loading path for this exact board. Do not infer Android fastboot support
from the presence of a host `fastboot` executable.
