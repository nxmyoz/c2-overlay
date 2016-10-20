# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 flag-o-matic

EGIT_REPO_URI="git://github.com/mdrjr/c2_aml_libs.git"

DESCRIPTION="ODROID-C2 Amlogic Libraries"
HOMEPAGE="https://github.com/mdrjr/c2_aml_libs.git"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="~arm64"

RDEPEND="media-libs/alsa-lib"

src_prepare() {
	default

	rm -f amadec/*.so
	rm -f amavutils/*.so
	rm -f amcodec/*.so
}

src_compile() {
	emake -C amadec clean
	emake -C amavutils clean
	emake -C amcodec clean

	append-flags -w
	emake -j1 -C amadec
	emake -j1 -C amavutils
	emake -j1 -C amcodec
	#emake -j1 -C example
	#emake -j1 -C audio_codec all
}

src_install() {
	dodir "/usr/include" "/lib/firmware" "/etc/ld.so.conf.d"

	#dodir "/usr/lib64/aml_libs"
	#dosym /usr/lib64/aml_libs /usr/lib/aml_libs

	# amadec
	#into /usr/lib64/aml_libs
	dolib.so amadec/libamadec.so

	doheader amadec/include/*
	doheader amadec/*.h

	insinto /lib/firmware
	insopts -m644
	doins amadec/firmware/*.bin


	# amavutils
	#into /usr/lib64/aml_libs
	dolib.so amavutils/libamavutils.so

	doheader amavutils/include/*
	doheader amavutils/include/cutils/*
	#dodir "/usr/include/cutils"
	#insinto /usr/include/cutils
	#doins amavutils/include/cutils/* /usr/include/cutils

	# amcodec
	#into /usr/lib64/aml_libs
	dolib.so amcodec/libamcodec.so

	dodir "/usr/include/amcodec"
	insinto /usr/include/amcodec
	doins -r amcodec/include/*

	# audio_codec
	#dolib.so audio_codec/libadpcm/libadpcm.so
	#dolib.so audio_codec/libamr/libamr.so
	#dolib.so audio_codec/libape/libape.so
	#dolib.so audio_codec/libcook/libcook.so
	#dolib.so audio_codec/libfaad/libfaad.so
	#dolib.so audio_codec/libflac/libflac.so
	#dolib.so audio_codec/liblpcm/liblibpcm_wfd.so
	#dolib.so audio_codec/libmad/libmad.so
	#dolib.so audio_codec/libpcm/libpcm.so
	#dolib.so audio_codec/libraac/libraac.so

	# example player
	#dobin example/esplayer

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-amlogic.rules

	# since we install to th elibdir directly, no need for additional conf file for ld
	#insinto /etc/ld.so.conf.d
	#doins "${FILESDIR}"/aml.conf

}
