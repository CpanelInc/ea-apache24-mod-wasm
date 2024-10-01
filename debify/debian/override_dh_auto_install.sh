#!/bin/bash

source debian/vars.sh

set -x

rm -rf $DEB_INSTALL_ROOT
confdir=$DEB_INSTALL_ROOT/etc/apache2/conf.modules.d/
moddir=$DEB_INSTALL_ROOT/etc/apache2/modules
optdir=$DEB_INSTALL_ROOT/opt/cpanel/$name
libdir=$DEB_INSTALL_ROOT/lib

mkdir -p $optdir
mkdir -p $libdir
mkdir -p $confdir
mkdir -p $moddir

cp LICENSE $optdir
cp README.md $optdir
cp mod_wasm.so $moddir
cp libwasm_runtime.so $libdir
cp $SOURCE1 $confdir

chmod 0755 $moddir/mod_wasm.so
chmod 0755 $libdir/libwasm_runtime.so
chmod 0644 $confdir/850_mod_wasm.conf

