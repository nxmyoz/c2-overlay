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
IUSE=""

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_compile() {
	emake all
}
