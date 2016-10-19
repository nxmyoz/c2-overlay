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
	emake -C audio_codec all
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

	# audio_codec
	dolib.so audio_codec/libadpcm/libadpcm.so
	dolib.so audio_codec/libamr/libamr.so
	dolib.so audio_codec/libape/libape.so
	dolib.so audio_codec/libcook/libcook.so
	dolib.so audio_codec/libfaad/libfaad.so
	dolib.so audio_codec/libflac/libflac.so
	dolib.so audio_codec/liblpcm/liblibpcm_wfd.so
	dolib.so audio_codec/libmad/libmad.so
	dolib.so audio_codec/libpcm/libpcm.so
	dolib.so audio_codec/libraac/libraac.so

	# example player
	#dobin example/esplayer

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-amlogic.rules

	insinto /etc/ld.so.conf.d
	doins "${FILESDIR}"/aml.conf

}
