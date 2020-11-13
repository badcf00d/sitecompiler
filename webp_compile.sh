#!/bin/bash

OS_PACKAGE_MANAGER=$1
OS_PACKAGE_MANAGER_FLAGS=$2

LESS_PIPE="BEGIN { ORS=\"\\r\"; print \"Starting...\" } { print \"\033[2K\"; print \$0 } END { print \"\033[2K\"; print \"Done\\n\" }"

$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS libjpeg-dev libpng-dev libtiff-dev libgif-dev | awk "$LESS_PIPE"

mkdir -p ~/libwebp_sources
cd ~/libwebp_sources

wget -q https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz
tar xzvf libwebp-1.1.0.tar.gz | awk "$LESS_PIPE"

cd libwebp-1.1.0
./configure --enable-shared=false | awk "$LESS_PIPE"
make -j$(grep -c ^processor /proc/cpuinfo) 2>&1 | awk "$LESS_PIPE"
sudo make install | awk "$LESS_PIPE"

hash -r
source ~/.profile
