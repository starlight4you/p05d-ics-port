# P-05D Android 4.0.4 自行移植工程

日期：2026-11-02。目标机为当前 ADB 连接的 P-05D / pana2_4a。

**状态：适配起始工程与原厂材料已建立，尚无可启动、可刷写的 Android 4.0 ROM。**
没有刷写、解锁、擦除、修改系统或安装应用。`adb root` 仍返回 `adbd cannot run as root in production builds`；但设备已通过
CCS 内核补丁获得 `/system/xbin/su` root，当前 shell 可用 `su -c` 读取原厂分区。

## 已完成

- 对设备重新采集硬件、分区、输入、显示和启动权限证据，见 `evidence/`。
- 从当前原厂系统采集 704 个文件，逐文件保存 SHA-256；9 个拒绝读取的文件
  单独记入 `evidence/capture-manifest.json`，没有将失败当作备份成功。
- 保存原厂系统库、PowerVR SGX540 图形栈、TI 固件、内核模块与输入映射到
  `stock/`，仅作为本机移植材料；这不是全分区备份。
- 生成 326 个 ELF 文件的依赖、导入及导出符号清单，见
  `evidence/elf-inventory.json` 和 `evidence/abi-report.md`。
- 通过 root 捕获 `/init.rc`、`/init.pana2_4a.rc`、`/proc/cmdline` 与 kernel 分区
  （CertISW 容器），保存到 `stock/init/` 与 `stock/partitions/`。
- 将捕获的 init/ueventd/media_profiles 纳入 `device/panasonic/pana2_4a/`，
  作为 ICS 适配输入。
- 建立 `device/panasonic/pana2_4a/`，面向 AOSP `android-4.0.4_r2.1`：
  ARMv7 NEON、OMAP4、240 dpi、实测分区容量，以及物理按键与触控初始配置。
  软件渲染、音频占位与相机占位用于第一阶段用户空间试验。
- 下载 AOSP ICS HAL 头文件及 panda 参考配置到 `reference/`，引用记录在
  `reference/sources.json`。panda 只用于核对 AOSP 构建方式，未作为兼容硬件。

## 实测约束

| 项目 | 结果 | 影响 |
|---|---|---|
| 原厂版本 | 2.3.5 / 07.5215，2.6.35.7+ 内核 | GB 驱动不能直接认定兼容 ICS |
| 显示 | omapfb，540×960，32 bpp | 首阶段评估 AOSP framebuffer + 软件 GLES |
| GPU | SGX540，用户库 1.1.17.4403 | 与内核 pvrsrvkm 的版本及 buffer 接口需匹配 |
| 内核模块 | TI 无线及大量厂商模块 | 新内核需要相应源码或兼容模块 |
| 相机 | libcamera.so 依赖 libsurfaceflinger_client.so 等旧接口 | 需要 ICS 驱动或专门封装/移植 |
| 音频 | GB libaudio.so、alsa.omap4.so | 需核对 ICS 音频 HAL/C++ ABI |
| /dev/ion | 不存在 | 不能直接搬用基于 ION 的其他 OMAP4 驱动 |
| 原厂 init / kernel 分区 | root 可读（/system/xbin/su）；init.rc/init.pana2_4a.rc/cmdline 已采集；kernel 分区为 CertISW 容器 | 可提取厂商初始化，但 kernel 容器格式/签名仍需解析 |
| /proc/config.gz | 不存在 | 未获得原厂内核配置 |
| Bootloader 解锁、临时启动、恢复 | 未验证 | 没有可执行的上机测试/恢复流程 |

## 源码查找新增证据

恢复的[松下 GPL 目录存档](https://web.archive.org/web/20130602163857/http://panasonic.jp/mobile/gpl/)
确实包含 P-05D 条目，目标为
`/mobile/cgi-bin/gpl/jp/action.pl?ua=p05d`；英文版对应 `en/action.pl`。
当前 GPL 首页返回 404。已尝试的日文下载入口回放没有返回原厂源码页面，
对应 2013 年 calendar 查询为空，精确 CDX 查询返回空数组。
随后成功恢复英文 P-05D 源码页：它是要求 IMEI 的 POST 下载表单，字段为
`action=entry`、`ua=p05d`、`input_number`，页面自身没有源码文件链接。
未向任何服务器提交本机 IMEI，也未取得源码载荷。
对整个 GPL CGI 目录筛选 P-05D 的 CDX 补充请求在 20 秒后超时，没有取得索引。
这些结果仅覆盖本次请求，不证明所有历史存档或私人镜像均不存在。
原始页面与请求结果保存在 `evidence/source-search/`。

## 当前阻碍与继续实施顺序

1. ~~取得本机原厂 kernel 分区及 ramdisk/init~~：已通过 root 读取
   `/init.rc`、`/init.pana2_4a.rc`、`/proc/cmdline` 与 `/dev/block/mmcblk0p8`
   （CertISW 容器，20 MiB）；ramdisk 仍需从容器或启动流程中提取。
2. 解析 kernel 容器格式、加载地址、内核命令行（已获 cmdline）、USB、挂载、
   供电和厂商模块初始化，确认可恢复的临时启动或刷写入口。不能以普通
   Android boot.img/fastboot 为前提。
3. 如复用旧内核，核查 binder、ashmem、帧缓冲、输入、文件系统及 Android 4.0
   所需接口；如重编译，先取得本机板级源码、配置与可兼容的专有模块。
4. 在兼容历史 Linux 构建环境中检出 AOSP，编译用户空间并解决实际编译错误。
   本机是 macOS ARM64，尚未配置 ICS 构建环境；没有执行完整 AOSP 编译。
5. 有可恢复启动链后，上机验证 ADB、挂载、显示、触控，再逐项移植 GPU、
   音频、Wi-Fi、基带、相机、电源管理。当前这些功能均未在 ICS 上验证。

目前工程只提供 `systemimage` 方向的初始配置，明确禁用 kernel/recovery 等产物。
尚未构建 system.img，也没有刷机 ZIP。不能用这个目录直接刷机。

## 本地工具

```sh
python3 porting/tools/capture.py
python3 porting/tools/audit_elf.py
```

`capture.py` 固定目标序列号并核对 pana2_4a，仅执行只读 shell 和 pull；
不采集 userdata、身份/校准私有分区。`audit_elf.py` 在本地分析 ELF32 ARM 文件，
不在设备上执行这些二进制。SHA-256 仅确认采集文件一致性，不证明 ICS 兼容。
