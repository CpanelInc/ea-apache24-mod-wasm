Name: ea-apache24-mod-wasm
Version: 0.12.2
Summary: mod_wasm is an Apache Server (httpd) extension module able to run and serve WebAssembly binaries as endpoints.

# Doing release_prefix this way for Release allows for OBS-proof versioning, See EA-4556 for more details
%define release_prefix 1
License: Apache License, Version 2.0
Release: %{release_prefix}%{?dist}.cpanel
Group: System Environment/Daemons
Vendor: cPanel, Inc.
URL: https://github.com/vmware-labs/mod_wasm
Source: v%{version}.tar.gz

Source1: 850_mod_wasm.conf

Requires: ea-apache24

%description
mod_wasm is an extension module for the Apache HTTP Server (httpd) that enables the usage of WebAssembly (Wasm). This module allows the execution of certain tasks in the backend in a very efficient and secure way.

%prep
%setup -q -n v%{version}

%build

%install
set -x

rm -rf %{buildroot}

confdir=%{buildroot}/etc/apache2/conf.modules.d
moddir=%{buildroot}/etc/apache2/modules
optdir=%{buildroot}/opt/cpanel/%{name}
libdir=%{buildroot}/usr/lib64

mkdir -p $optdir
mkdir -p $libdir
mkdir -p $confdir
mkdir -p $moddir

cp LICENSE $optdir
cp README.md $optdir
cp mod_wasm.so $moddir
cp libwasm_runtime.so $libdir
cp %{SOURCE1} $confdir

chmod 0755 $moddir/mod_wasm.so
chmod 0755 $libdir/libwasm_runtime.so
chmod 0644 $confdir/850_mod_wasm.conf

%clean
rm -rf %{buildroot}

%files
/opt/cpanel/%{name}
/usr/lib64/libwasm_runtime.so
/etc/apache2/modules/mod_wasm.so
/etc/apache2/conf.modules.d/850_mod_wasm.conf

%changelog
* Wed Sep 25 2024 Julian Brown <julian.brown@webpros.com> - 0.12.2-1
- ZC-12191: Created Apache Module

