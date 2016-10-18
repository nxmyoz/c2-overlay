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
	AML_LIBS_DIR="/usr/lib64/aml_libs"

	dodir "/usr/include" "/lib/firmware" "${AML_LIBS_DIR}" "/etc/ld.so.conf.d"

	# amadec
	insinto "${AML_LIBS_DIR}"
	doins amadec/libamadec.so

	doheader amadec/include/*
	doheader amadec/*.h

	insinto  /lib/firmware
	doins amadec/firmware/*.bin


	# amavutils
	insinto "${AML_LIBS_DIR}"
	doins amavutils/libamavutils.so

	doheader amavutils/include/*

	# amcodec
	insinto "${AML_LIBS_DIR}"
	doins amcodec/libamcodec.so

	dodir "/usr/include/amcodec"
	insinto /usr/include/amcodec
	doins amcodec/include/*

	# audio_codec
		# libadpcm
		# libamr
		# libape
		# libcoock
		# libfaad
		# libflac
		# libpcm
		# libmad
		# libpcm
		# libraac


	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-amlogic.rules

	insinto /etc/ld.so.conf.d
	doins "${FILESDIR}"/aml.conf

	dosym "${AML_LIBS_DIR}" /usr/lib/aml_libs

}
