#!/bin/bash

VERSION=$(grep "Version:" /vagrant/python3-pyotp.spec |cut -d ":" -f2 |tr -d "[:space:]")
RELEASE=$(grep "Release:" /vagrant/python3-pyotp.spec |cut -d ":" -f2 |tr -d "[:space:]")
ARCH=$(grep "BuildArch:" /vagrant/python3-pyotp.spec |cut -d ":" -f2 |tr -d "[:space:]")

echo "Version: $VERSION-$RELEASE BuildArch: $ARCH"

# Exclude kernels from update as they may break hgfs under VMWare
yum --exclude=kernel\* update -y
yum -y install rpmdevtools python3-devel python3-setuptools
if [ ! -f /root/.rpmmacros ];
then
  rpmdev-setuptree
fi

if [ ! -f /root/rpmbuild/SOURCES/pyotp-$VERSION.targ.gz ];
then
  curl -L -o  /root/rpmbuild/SOURCES/pyotp-$VERSION.tar.gz https://files.pythonhosted.org/packages/source/p/pyotp/pyotp-$VERSION.tar.gz
fi

cp "/vagrant/python3-pyotp.spec" "/root/rpmbuild/SPECS/"

if [ ! -f /vagrant/python3-pyotp-$VERSION-$RELEASE.noarch.rpm ];
then
  cd /root/rpmbuild
  rpmbuild --buildroot "/root/rpmbuild/BUILDROOT" /root/rpmbuild/SPECS/python3-pyotp.spec -bb
  cp /root/rpmbuild/RPMS/noarch/python3-pyotp-$VERSION-$RELEASE.noarch.rpm /vagrant
fi
