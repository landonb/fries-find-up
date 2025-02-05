#!/bin/sh -ex

GH_USER="landonb"
GH_REPO="fries-findup"
VERSION="0.0.3"

TMPDIR="$(mktemp -d 2>/dev/null || mktemp -d -t "tmp.XXXXXXXXXX")"

REPODIR="${TMPDIR}/${GH_REPO}-${VERSION}"

REPOTAR="https://github.com/${GH_USER}/${GH_REPO}/archive/${VERSION}.tar.gz"

cd "${TMPDIR}"
curl -sL "${REPOTAR}" | gunzip | tar xf -
cd "${REPODIR}"
make install
cd "${TMPDIR}"
command rm -rf -- "${REPODIR}"

