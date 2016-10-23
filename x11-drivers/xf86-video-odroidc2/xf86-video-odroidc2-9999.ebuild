# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils xorg-2 git-r3

EGIT_REPO_URI="https://github.com/mdrjr/c2_mali_ddx.git"
SRC_URI=""

DESCRIPTION="X.org Mali video driver for ODROID-C2"
HOMEPAGE="http://www.hardkernel.com/"

KEYWORDS="~arm64"
SLOT=0

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	media-libs/odroidc2-mali[x11]
	x11-proto/fontsproto
	x11-proto/xproto
	x11-libs/libdrm"

	#PATCHES=( "${FILESDIR}/0001-Fix-DESTDIR-when-performing-install.patch" )

src_prepare() {
	emake distclean
}

src_compile() {
	autotools-utils_src_compile
	#cp "./src/xorg.conf" "${BUILD_DIR}/src/xorg.conf"
}

