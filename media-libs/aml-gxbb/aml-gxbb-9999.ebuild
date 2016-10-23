# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 flag-o-matic

EGIT_REPO_URI="git://github.com/mdrjr/c2_aml_libs.git"

DESCRIPTION="Amlogic VPU Libraries for ODROID-C2 (S905), e.g. meson-gxbb"
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
	append-flags -w
	append-ldflags -Wl,-soname,libamadec.so
	emake -j1 -C amadec
	append-ldflags -Wl,-soname,libamavutils.so
	emake -j1 -C amavutils

	emake -j1 -C amcodec

	#emake -j1 -C example
	#emake -j1 -C audio_codec all
}

src_install() {
	dodir "/usr/include" "/lib/firmware" "/etc/ld.so.conf.d"

	dodir "/usr/lib64/aml_libs"

	# amadec
	dolib.so amadec/libamadec.so
	dosym /usr/lib64/aml_libs/libamadec.so /usr/lib64/libamadec.so

	doheader amadec/include/*
	doheader amadec/*.h

	insinto /lib/firmware
	insopts -m644
	doins amadec/firmware/*.bin


	# amavutils
	dolib.so amavutils/libamavutils.so
	dosym /usr/lib64/aml_libs/libamavutils.so /usr/lib64/libamavutils.so

	doheader amavutils/include/*
	doheader amavutils/include/cutils/*

	# amcodec
	dolib.so amcodec/libamcodec.so
	dosym /usr/lib64/aml_libs/libamcodec.so /usr/lib64/libamcodec.so

	dodir "/usr/include/amcodec"
	insinto /usr/include/amcodec
	doins -r amcodec/include/*

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-amlogic.rules

	# since we install to th elibdir directly, no need for additional conf file for ld
	#insinto /etc/ld.so.conf.d
	#doins "${FILESDIR}"/aml.conf
}
