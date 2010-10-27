# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# EAPI="2"

DESCRIPTION="Discount is a Markdown implementation written in C."
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/discount/${P}.tar.gz"
#SRC_URI="http://github.com/Orc/discount/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD Styled"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="minimal"
RESTRICT="mirror"

src_compile() {
	local myconf

	if use minimal ; then
		myconf="${myconf}"
	else
		myconf="${myconf} --enable-all-features"
	fi
	# econf makes poor self written tool kill self
	./configure.sh --prefix=${EPREFIX}/usr ${myconf}

	emake || die "emake failed"
}

src_install() {
	# set up less install if minimal is enabled
	myinstall="install.everything"
	use minimal && myinstall="install"

	# make will fail if these folders don't exist
	dodir /usr/bin
	dodir /usr/share/man
	dodir /usr/include
	dodir /usr/lib

	# for QA, we remove the Makefiles usage of install -s
	sed -i -e "s:/usr/bin/install -s:/usr/bin/install:" Makefile \
	|| die "sed can't fix stripping of files"

	emake DESTDIR="${D}" ${myinstall} \
	|| die "install failed"
}
