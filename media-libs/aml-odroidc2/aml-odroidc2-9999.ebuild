# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

EGIT_REPO_URI="git://github.com/mdrjr/c2_aml_libs.git"

DESCRIPTION="ODROID-C2 Amlogic Libraries"
HOMEPAGE="https://github.com/mdrjr/c2_aml_libs.git"
LICENSE="all-rights-reserved"

SLOT="0"

RDEPEND="media-libs/alsa-lib"

src_compile() {
	emake -C amadec
	emake -C amavutils
	emake -C amcodec
	#emake -C example
	#emake -C audio_codec all
}

src_install() {
	dodir "/usr/include" "/lib/firmware" "/etc/ld.so.conf.d"

	# amadec
	dolib.so amadec/libamadec.so

	doheader amadec/include/*
	doheader amadec/*.h

	insinto /lib/firmware
	insopts -m644
	doins amadec/firmware/*.bin


	# amavutils
	dolib.so amavutils/libamavutils.so

	doheader amavutils/include/*

	# amcodec
	dolib.so amcodec/libamcodec.so

	dodir "/usr/include/amcodec"
	insinto /usr/include/amcodec
	doins amcodec/include/*

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-amlogic.rules

	insinto /etc/ld.so.conf.d
	doins "${FILESDIR}"/aml.conf

}
