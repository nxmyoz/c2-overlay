ODROID-C2 Gentoo Overlay
========================

Status:

* `media-libs/aml-odroidc2`: Odroid C2 Amlogic Libraries (https://github.com/mdrjr/c2_aml_libs)
* `sys-kernel/odroidc2-sources`: Linux source for ODROID-C2 (https://github.com/hardkernel/linux)

WIP:

* `x11-drivers/xf86-video-odroidc2`: Xorg DDX driver for ODROID-C2 (https://github.com/hardkernel/mdrjr/c2_mali_ddx)
* `x11-libs/odroidc2-mali`: ARM closed source Mali drivers (https://github.com/hardkernel/mdrjr/c2_mali

U-Boot:

ODROID-C2 is nasty here, native compiling on the C2 itslef won't work. At this moment compilation has to be on a x86-64 machine with according crossdev setup. (https://github.com/hardkernel/u-boot/issues/23)

A workaround via binfmt will not work natively on Gentoo, because of https://bugs.gentoo.org/show_bug.cgi?id=484886.


Layman
-----------------

```
$ wget "https://raw.githubusercontent.com/nxmyoz/c2-overlay/master/overlays.xml" -O /etc/layman/overlays/odroidc2.xml
$ layman -f -a ODROID-C2
```
