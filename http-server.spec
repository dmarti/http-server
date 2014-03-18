Name:		http-server
Version:	%(echo -n $VERSION)
Summary:	Basic minimal HTTP server
BuildArch:	x86_64
Release:	1
AutoReqProv:	no

Group:		Development/Tools
License:	GPLv2
URL:		http://zgp.org/~dmarti/
Source0:	http-server.c
Source1:	Makefile

BuildRoot:	 %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u}%-n)

Requires:	libevent
BuildRequires:	libevent-devel

%description
Minimal static HTTP server based on libevent.

%prep
pwd
cp ../SOURCES/* .

%build
make %{?_smp_mflags} http-server

%install
make install DESTDIR=%{buildroot}

%files 
%doc
/usr/sbin/http-server

