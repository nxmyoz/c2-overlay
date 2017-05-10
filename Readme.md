ODROID-C2 Gentoo Overlay
========================

# Introduction

This is a Gentoo overlay for additional tools neccessary for running Gentoo Linux on the Hardkernel ODROID C2 single board computer. More information about the ODROID c2 can be found [here](http://odroid.com/dokuwiki/doku.php?id=en:odroid-c2).

At the moment this overlay provides:

Package Name | Description
------------ | -------------
sys-boot/meson-tools | [meson-tools](https://github.com/afaerber/meson-tools), alternative to aml_encrypt_gxb
sys-boot/odroidc2-fip | [fip_create](https://github.com/hardkernel/u-boot/tree/odroidc2-v2015.01/tools/fip_create) and Hardkernel's ARM Trusted Firmware [binaries](https://github.com/hardkernel/u-boot/tree/odroidc2-v2015.01/fip) from their repository
sys-boot/u-boot-odroidc2 | Mainline U-Boot

### Some Notes
At this moment all that is described in here will give you a headless setup, without any multimedial features, such as graphics (don't even think of accelerated graphics as of yet) nor sound via hdmi.
Despite the mainline kernel having gained some support for hdmi, it is of no use at this present moment.

Please refer to the mainling project at http://linux-meson.com.

# Installation
Obviously, if you already know what an Gentoo overlay is and how to use one, detailed instructions on how to bring Gentoo onto the C2 are not needed. You've clearly the expertise.

## Layman
```bash
wget "https://raw.githubusercontent.com/nxmyoz/c2-overlay/master/overlays.xml" -O /etc/layman/overlays/odroidc2.xml
layman -f -a ODROID-C2
```

## make.conf

The most important stuff:

```bash
CFLAGS="-O2 -pipe  -march=armv8-a+crc+fp+simd -mabi=lp64 -mcpu=cortex-a53+crc+fp+simd"
CXXFLAGS="${CFLAGS}"
CHOST="aarch64-unknown-linux-gnu"
MAKEOPTS="-j4"
CPU_FLAGS_ARM="edsp neon thumb vfp vfpv3 vfpv4 vfp-d32 crc32 v4 v5 v6 v7 v8 thumb2"
```

llvm won't build with `MAKEOPTS="-j4"`, so a workaround is needed, like per package env, setting the `MAKEOPTS` to `-j2`:

```
# cat /etc/portage/package.env
sys-devel/llvm makeopts-j2

# cat /etc/portage/env/makeopts-j2
MAKEOPTS="-j2"
```


# U-Boot

Mainline U-Boot support, with booting from the mmc & sd is available starting with 2017.05.

You will need to install [sys-boot/u-boot-tools](https://packages.gentoo.org/packages/dev-embedded/u-boot-tools) should you desire to generate your own boot.scr boot script.

The ebuilds provided in this overlay aim to make life simpler by providing all that is needed to build a working U-Boot.

#### Howto U-Boot with Gentoo
1. Use this overlay
2. `emerge -av meson-tools odroidc2-fip u-boot-odroidc2`

`odroidc2-fip` will provide the following files:
```
/usr/bin/fip_create
/usr/share/odroidc2-fip/bl1.bin.hardkernel
/usr/share/odroidc2-fip/bl2.package
/usr/share/odroidc2-fip/bl30.bin
/usr/share/odroidc2-fip/bl301.bin
/usr/share/odroidc2-fip/bl31.bin
/usr/share/odroidc2-fip/sd_fusing.sh
```

while `u-boot-odroidc2` will just build the u-boot image with using the `odroid-c2_defconfig`, and install the resulting image in `/usr/share/u-boot-odroidc2/u-boot-${PV}.bin`, e.g. for `sys-boot/u-boot-odroidc2-2017.05` it would be `/usr/share/u-boot-odroidc2/u-boot-2017.05.bin`.

You now can simply generate u-boot in the neccessary format by, [as described in u-boot sources](http://git.denx.de/?p=u-boot.git;a=blob_plain;f=board/amlogic/odroid-c2/README;hb=HEAD), however without the ivokation of `aml_encrypt_gxb`:

```bash
PV="2017.05"
DIR=~/.
FDIR=/usr/share/odroidc2-fip

fip_create  --bl30 $FDIR/bl30.bin \
            --bl301 $FDIR/bl301.bin \
            --bl31 $FDIR/bl31.bin \
            --bl33 /usr/share/u-boot-odroidc2/u-boot-${PV}.bin \
            $DIR/fip.bin

fip_create --dump $DIR/fip.bin
cat $FDIR/bl2.package $DIR/fip.bin > $DIR/boot_new.bin
amlbootsig $DIR/boot_new.bin $DIR/u-boot.img
dd if=$DIR/u-boot.img of=$DIR/u-boot.gxbb bs=512 skip=96
```
Now write it to your boot device (mmc or sd):

```bash
DEV=/dev/mmcblk0
BL1=$FDIR/bl1.bin.hardkernel
dd if=$BL1 of=$DEV conv=fsync bs=1 count=442
dd if=$BL1 of=$DEV conv=fsync bs=512 skip=1 seek=1
dd if=$DIR/u-boot.gxbb of=$DEV conv=fsync bs=512 seek=97
```
That should work.

# Kernel (gentoo-sources)
A minimal (at least from my perspective) kernel config for `>=sys-kernel/gentoo-sources-4.11` can be found in this repository [here](https://github.com/nxmyoz/c2-overlay/blob/master/c2.config).

Here are the steps in building the kernel:

```bash
cd /usr/src/linux
make mrproper clean
wget "https://raw.githubusercontent.com/nxmyoz/c2-overlay/master/c2.config" -O .config

make -j4 Image
make -j4 modules
make -j4 dtbs

rm -rf /lib/modules/*

make modules_install

cp -rf arch/arm64/boot/Image /boot/Image
cp -rf arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb /boot/meson-gxbb-odroidc2.dtb
```

# Booting
Create and adjust as needed a `/boot/boot.cmd`:
```
setenv loadaddr "0x20000000"
setenv dtb_loadaddr "0x01000000"
setenv initrd_high "0xffffffff"
setenv fdt_high "0xffffffff"
setenv kernel_filename boot/Image
setenv fdt_filename boot/meson-gxbb-odroidc2.dtb
setenv bootargs "root=/dev/mmcblk0p1 rootfstype=ext4 rootwait rw"
setenv bootcmd "ext4load mmc 0:1 '${loadaddr}' '${kernel_filename}'; ext4load mmc 0:1 '${dtb_loadaddr}' '${fdt_filename}'; booti '${loadaddr}' - '${dtb_loadaddr}'"
boot
```
Then run:
```
mkimage -C none -A arm -T script -d boot.cmd boot.scr
```

U-Boot should now be able to find and use `boot.scr`.
