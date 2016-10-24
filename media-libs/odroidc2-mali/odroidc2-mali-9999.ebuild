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

IUSE="fbdev X"


src_compile() {
	touch .gles-only
}

src_install() {
	# X
	if use X ; then
		local opengl_imp_x11="mali-x11"
		local opengl_dir_x11="/usr/$(get_libdir)/opengl/${opengl_imp_x11}"

		dodir "${opengl_dir_x11}/lib" "${opengl_dir_x11}/include" "${opengl_dir_x11}/extensions"

		insinto ${opengl_dir_x11}/include
		doins -r x11/mali_headers/*

		insinto "${opengl_dir_x11}/lib"
		insopts -m755
		doins x11/mali_libs/libUMP.so
		doins x11/mali_libs/libMali.so
		dosym "${D}/${opengl_dir_x11}/include/ump" "/usr/include/ump"
		dosym "${D}/${opengl_dir_x11}/include/umplock" "/usr/include/umplock"

		local libMali_x11="${opengl_dir_x11}/lib/libMali.so"
		#dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libMali.so"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libEGL.so"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libEGL.so.1"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libEGL.so.1.4"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv1_CM.so"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv1_CM.so.1"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv1_CM.so.1.1"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv2.so"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv2.so.2"
		dosym "${libMali_x11}" "${opengl_dir_x11}/lib/libGLESv2.so.2.0"

		insinto "${opengl_dir_x11}"
		doins .gles-only

	fi

	# fbdev
	if use fbdev ; then
		local opengl_imp_fbdev="mali-fbdev"
		local opengl_dir_fbdev="/usr/$(get_libdir)/opengl/${opengl_imp_fbdev}"

		dodir "${opengl_dir_fbdev}/lib" "${opengl_dir_fbdev}/include" "${opengl_dir_fbdev}/extensions"

		insinto ${opengl_dir_fbdev}/include
		doins -r fbdev/mali_headers/*

		insinto "${opengl_dir_fbdev}/lib"
		insopts -m755
		doins fbdev/mali_libs/libMali.so

		local libMali_fbdev="${opengl_dir_fbdev}/lib/libMali.so"
		#dosym "${libMali_fbdev}" "${opengl_dir_fbdev}/lib/libMali.so"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libEGL.so"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libEGL.so.1"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libEGL.so.1.4"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv1_CM.so"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv1_CM.so.1"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv1_CM.so.1.1"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv2.so"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv2.so.2"
		dosym "${libMali_fbdev}" "${opengl_dir_x11}/lib/libGLESv2.so.2.0"

		insinto "${opengl_dir_fbdev}"
		doins .gles-only
	fi

	# udev rules to get the right ownership/permission for /dev/ump and /dev/mali
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-mali-drivers.rules

}

pkg_postinst() {
	elog "You must be in the video group to use the Mali 3D acceleration."
	elog
	if use X ; then
		elog "To use the Mali OpenGL ES libraries, run \"eselect opengl set mali-x11\""
	fi
	if use fbdev ; then
		elog "To use the Mali OpenGL ES libraries, run \"eselect opengl set mali-fbdev\""
	fi
}

pkg_prerm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}

pkg_postrm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}
