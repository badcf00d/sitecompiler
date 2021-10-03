#!/bin/bash

OS_PACKAGE_MANAGER=$1
OS_PACKAGE_MANAGER_FLAGS=$2


$OS_PACKAGE_MANAGER update
$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libunistring-dev \
    pkg-config \
    texinfo \
    wget \
    yasm \
    zlib1g-dev \
    nasm \
    libx264-dev \
    libx265-dev libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ninja-build

cd ~/
if [ -d aom ]; then
    git -C aom pull
else
    git clone --depth 1 https://aomedia.googlesource.com/aom
fi

mkdir -p ~/aom_build
cd ~/aom_build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom 2>&1
make -j$(grep -c ^processor /proc/cpuinfo)
make install

mkdir -p ~/vmaf_build
cd ~/vmaf_build
if [ -d vmaf ]; then
    git -C vmaf pull
else
    git clone https://github.com/Netflix/vmaf.git
fi
sudo pip3 install meson Cython numpy
cd vmaf/libvmaf
meson setup --buildtype release --libdir lib build
ninja -vC build
sudo ninja -vC build install
sudo ldconfig

mkdir -p ~/ffmpeg_sources
cd ~/ffmpeg_sources
wget -q -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include -w" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --bindir="/usr/local/bin" \
    --enable-gpl \
    --enable-gnutls \
    --enable-libaom \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvmaf \
    --enable-nonfree \
   

make -j$(grep -c ^processor /proc/cpuinfo)
sudo make install
hash -r
source ~/.profile
