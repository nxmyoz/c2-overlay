# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Pre-built u-boot for ODROID-C2"
HOMEPAGE="https://github.com/mdrjr/c2_uboot_binaries"
EGIT_REPO_URI="git://github.com/mdrjr/c2_uboot_binaries"


LICENSE=""
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	return
}

src_install() {
	dodir "/usr/share/${PN}"
	insinto /usr/share/${PN}
	doins bl1.bin.hardkernel
	doins u-boot.bin
	doins sd_fusing.sh

	dodoc README
}
