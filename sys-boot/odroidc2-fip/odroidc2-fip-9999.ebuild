# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

EGIT_REPO_URI="https://github.com/hardkernel/u-boot.git"
EGIT_BRANCH="odroidc2-v2015.01"

LICENSE=""
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	cd tools/fip_create
	emake || die "Build failed!"
}

src_install() {
	dobin tools/fip_create/fip_create

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins fip/gxb/bl2.package
	doins fip/gxb/bl30.bin
	doins fip/gxb/bl301.bin
	doins fip/gxb/bl31.bin
}

