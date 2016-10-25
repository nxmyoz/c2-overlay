# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

EGIT_REPO_URI="git://github.com/mdrjr/c2_mali.git"

DESCRIPTION="Closed source drivers for Mali-450 ODROID-C2"
HOMEPAGE="https://github.com/mdrjr/c2_mali.git"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="~arm64"

DEPEND=">=app-eselect/eselect-opengl-1.2.6"
RDEPEND="${DEPEND}
	media-libs/mesa[gles1,gles2]"

IUSE="-fbdev X"
REQUIRED_USE="^^ ( fbdev X )"

src_compile() {
	touch .gles-only
}

src_install() {
	local opengl_imp="mali"
	local opengl_dir="/usr/$(get_libdir)/opengl/${opengl_imp}"

	dodir "${opengl_dir}/lib" "${opengl_dir}/include" "${opengl_dir}/extensions"

	insinto ${opengl_dir}/include

	if use X ; then
		doins -r x11/mali_headers/*
		dolib.so x11/mali_libs/libUMP.so
		dolib.so x11/mali_libs/libMali.so
		dosym "${opengl_dir}/include/ump" "/usr/include/ump"
		dosym "${opengl_dir}/include/umplock" "/usr/include/umplock"
	fi

	if use fbdev ; then
		doins -r fbdev/mali_headers/*
		dolib.so fbdev/mali_libs/libMali.so
	fi

	local libMali="$(get_libdir)/libMali.so"
	dosym "${libMali}" "${opengl_dir}/lib/libEGL.so"
	dosym "${libMali}" "${opengl_dir}/lib/libEGL.so.1"
	dosym "${libMali}" "${opengl_dir}/lib/libEGL.so.1.4"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv1_CM.so"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv1_CM.so.1"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv1_CM.so.1.1"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv2.so"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv2.so.2"
	dosym "${libMali}" "${opengl_dir}/lib/libGLESv2.so.2.0"

	insinto "${opengl_dir}"
	doins .gles-only


	# udev rules to get the right ownership/permission for /dev/ump and /dev/mali
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-mali-drivers.rules

}

pkg_postinst() {
	elog "You must be in the video group to use the Mali 3D acceleration."
	elog
	elog "To use the Mali OpenGL ES libraries, run \"eselect opengl set mali\""
}

pkg_prerm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}

pkg_postrm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}
