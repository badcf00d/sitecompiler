#!/bin/bash

OS_PACKAGE_MANAGER=$1
OS_PACKAGE_MANAGER_FLAGS=$2


$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS libjpeg-dev libpng-dev libtiff-dev libgif-dev

mkdir -p ~/libwebp_sources
cd ~/libwebp_sources

wget -q https://github.com/webmproject/libwebp/archive/refs/tags/v1.2.1.tar.gz
tar xzvf v1.2.1.tar.gz
rm -f v1.2.1.tar.gz

cd libwebp-1.2.1
./autogen.sh
./configure --enable-shared=false
make -j$(nproc) 2>&1
sudo make install

hash -r
source ~/.profile
