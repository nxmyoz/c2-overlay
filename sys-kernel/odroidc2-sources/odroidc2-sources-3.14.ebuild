# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ETYPE=sources
K_DEFCONFIG="odroidc2_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"

inherit kernel-2

detect_version
detect_arch

inherit git-r3 versionator

EGIT_REPO_URI="git://github.com/hardkernel/linux.git"
EGIT_BRANCH="odroidc2-$(get_version_component_range 1-2).y"
EGIT_CHECKOUT_DIR="$S"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="Linux source for Odroid devices"
HOMEPAGE="https://github.com/hardkernel/linux"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~arm64"

RDEPEND="sys-devel/bc
	app-arch/lzop"

src_unpack()
{
	git-r3_src_unpack
	unpack_set_extraversion
}


