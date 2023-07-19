%{!?configopts: %global configopts LDFLAGS=-Wl,--build-id}


# Define install_modulefile to 1 if you want this RPM to install a modulefile.
%{!?install_modulefile: %define install_modulefile 0}

# Define install_default_module_version to 1 if you want this RPM to install a .version file
%{!?install_default_module_version: %define install_default_module_version 0}

# Path to install modulefiles in
%{!?modulefile_path: %define modulefile_path /usr/share/Modules/modulefiles}

Name: libfabric
Version: 1.17.1
Release: 1%{?dist}
Summary: User-space RDMA Fabric Interfaces

Group: System Environment/Libraries
License: GPLv2 or BSD
Url: http://www.github.com/ofiwg/libfabric
Source: http://www.github.org/ofiwg/%{name}/releases/download/v{%version}/%{name}-%{version}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
%if 0%{?suse_version} >= 1
Provides: libfabric1 = %{version}-%{release}
%endif

%description
libfabric provides a user-space API to access high-performance fabric
services, such as RDMA.

%package devel
Summary: Development files for the libfabric library
Group: System Environment/Libraries
Requires: libfabric = %{version}

%description devel
Development files for the libfabric library.

%prep
%setup -q -n %{name}-%{version}

%build
%configure %{configopts}
make %{?_smp_mflags}

%install
rm -rf %{buildroot}

# First, the [optional] modulefile

%if %{install_modulefile}
%{__mkdir_p} %{buildroot}/%{modulefile_path}/%{name}/
cat <<EOF >%{buildroot}/%{modulefile_path}/%{name}/%{version}
#%Module -*- tcl -*-
#
# This file was automatically generated by Libfabric RPM.
#
# Modulefile for Libfabric %{version}
#

proc ModulesHelp { } {
   puts stderr \"\tThis module adds Libfabric %{version} to the environment.\"
}

module-whatis   \"This module adds Libfabric %{version} to the environment\"

prepend-path PATH %{_prefix}/bin
prepend-path LD_LIBRARY_PATH %{_libdir}
prepend-path MANPATH %{_mandir}
prepend-path PKG_CONFIG_PATH %{_libdir}/pkgconfig
EOF
%if %{install_default_module_version}
cat <<EOF >%{buildroot}/%{modulefile_path}/%{name}/.version
#%Module1.0
##
set ModulesVersion "%{version}"
EOF
%endif
%endif

%make_install installdirs
# remove unpackaged files from the buildroot
rm -f %{buildroot}%{_libdir}/*.la
%if 0%{?_version_symbolic_link:1}
%{__ln_s} %{version} %{buildroot}/%{_version_symbolic_link}
%endif

%clean
rm -rf %{buildroot}

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%defattr(-,root,root,-)
%{_libdir}/lib*.so.*
%{_bindir}/fi_info
%{_bindir}/fi_strerror
%{_bindir}/fi_pingpong
%if 0%{?_version_symbolic_link:1}
%{_version_symbolic_link}
%endif
%dir %{_libdir}/libfabric/
%doc AUTHORS COPYING README

%files devel
%defattr(-,root,root)
%{_libdir}/libfabric*.so
%{_libdir}/*.a
%{_libdir}/pkgconfig/libfabric.pc
%if %{install_modulefile}
%{modulefile_path}/%{name}/%{version}
%if %{install_default_module_version}
%{modulefile_path}/%{name}/.version
%endif
%dir %{modulefile_path}
%endif
%{_includedir}/*
%{_mandir}/man1/*
%{_mandir}/man3/*
%{_mandir}/man7/*

%changelog
* Fri Jun 26 2015 Open Fabrics Interfaces Working Group <ofiwg@lists.openfabrics.org> 1.1.0rc1
- Release 1.1.0rc1
* Sun May 3 2015 Open Fabrics Interfaces Working Group <ofiwg@lists.openfabrics.org> 1.0.0
- Release 1.0.0
