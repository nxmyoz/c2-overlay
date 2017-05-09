ODROID-C2 Gentoo Overlay
========================

Status (done):

As Amlogic's SoCs are gainig support in mainline kernel - and since Odroid C2 works with gentoo-sources-4.11 - the media-libs and x11/fbdev drivers from amlogic/Hardkernel are dropped in favor of some waiting for further inclusion of features in mainline kernel.

Gentoo runs without any problems headless on the Odroid C2, pretty fast, too. (Albeit video via hdmi as well as sound via hdmi is missing at the moment).


U-Boot:

Mainline U-Boot support is available starting 2017.05.

Follow the U-Boot's instruction for building it: http://git.denx.de/?p=u-boot.git;a=blob_plain;f=board/amlogic/odroid-c2/README;hb=HEAD



ODROID-C2 is nasty here, native compiling on the C2 itslef won't work. At this moment compilation has to be on a x86-64 machine with according crossdev setup. (https://github.com/hardkernel/u-boot/issues/23)

A workaround via binfmt will not work natively on Gentoo, because of https://bugs.gentoo.org/show_bug.cgi?id=484886.

Layman
-----------------

```
$ wget "https://raw.githubusercontent.com/nxmyoz/c2-overlay/master/overlays.xml" -O /etc/layman/overlays/odroidc2.xml
$ layman -f -a ODROID-C2
```

make.conf
-----------------

The most important stuff:

```
CFLAGS="-O2 -pipe  -march=armv8-a+crc+fp+simd -mabi=lp64 -mcpu=cortex-a53+crc+fp+simd"
CXXFLAGS="${CFLAGS}"
CHOST="aarch64-unknown-linux-gnu"
MAKEOPTS="-j4"
CPU_FLAGS_ARM="edsp neon thumb vfp vfpv3 vfpv4 vfp-d32 crc32 v4 v5 v6 v7 v8 thumb2"
```

llvm won't build with MAKEOPTS="-j4", so a workaround is needed, like per package env.
