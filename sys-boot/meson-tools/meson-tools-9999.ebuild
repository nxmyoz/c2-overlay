# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 flag-o-matic

DESCRIPTION="A collection of tools for use with the Amlogic Meson family of ARM based SoCs"
HOMEPAGE="https://github.com/afaerber/meson-tools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/afaerber/meson-tools.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64 ~arm"
IUSE="+amlbootsig +unamlbootsig +amlinfo"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_compile() {
	if use amlbootsig ; then
		emake amlbootsig || die "Make failed!"
	fi

	if use unamlbootsig ; then
		emake unamlbootsig || die "Make failed!"
	fi

	if use amlinfo ; then
		emake amlinfo || die "Make failed!"
	fi
}

src_install() {
	if use amlbootsig ; then
		dosbin amlbootsig
	fi

	if use unamlbootsig ; then
		dosbin unamlbootsig
	fi

	if use amlinfo ; then
		dosbin amlinfo
	fi
}
