# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mali GPU User-Space Binary Drivers"
HOMEPAGE="https://developer.arm.com/products/software/mali-drivers/user-space"
SRC_URI="
	arm64?	( https://developer.arm.com/-/media/Files/downloads/mali-drivers/user-space/hikey/mali450${PV}001rel0linux1arm64tar.gz )
	arm?	( https://developer.arm.com/-/media/Files/downloads/mali-drivers/user-space/hikey/mali450${PV}001rel0linux1armhftar.gz )
"

LICENSE="ARM-EULA no-sorce-code"
SLOT="0"
KEYWORDS="~arm64"
IUSE="fbdev wayland"

DEPEND=">=app-eselect/eselect-opengl-1.2.6"
RDEPEND="
	${DEPEND}"
	media-libs/mesa[gles1,gles2]
"
src_install() {
	local opengl_

