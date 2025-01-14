# ----------------------------------------------------------------------------
#
# Package       : netty-tcnative
# Version       : 7.8.1
# Source repo   : https://github.com/netty/netty-tcnative.git
# Tested on     : rhel 8.3
# Script License: Apache License Version 2.0
# Maintainer    : Sachin Kakatkar <sachin.kakatkar@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
#!/bin/bash

WORKDIR=`pwd`
PACKAGE_NAME=netty-tcnative
PACKAGE_VERSION=$1
PACKAGE_URL=https://github.com/netty/netty-tcnative.git

if [ -z "$1" ]
  then
    PACKAGE_VERSION=netty-tcnative-parent-2.0.25.Final
fi

dnf install make maven git sudo wget gcc-c++ apr-devel perl openssl-devel automake autoconf libtool -y

#Install cmake 21 and above
wget https://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2.tar.gz
tar -xvf cmake-3.21.2.tar.gz
cd cmake-3.21.2
./bootstrap
make
make install
cd ..

#Install go lang
wget https://golang.org/dl/go1.17.linux-ppc64le.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-ppc64le.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

#Install Ninja tool
git clone git://github.com/ninja-build/ninja.git && cd ninja
git checkout v1.10.2
cmake -Bbuild-cmake -H.
cmake --build build-cmake
sudo ln -sf $WORKDIR/ninja/build-cmake/ninja /usr/bin/ninja
cd ..

#Build and test
git clone $PACKAGE_URL
cd netty-tcnative
git checkout $PACKAGE_VERSION
./mvnw clean install
