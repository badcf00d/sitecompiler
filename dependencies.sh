#!/bin/bash

OS_PACKAGE_MANAGER=
OS_PACKAGE_MANAGER_FLAGS=

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_PACKAGE_MANAGER="sudo apt-get"
	OS_PACKAGE_MANAGER_FLAGS="-y"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_PACKAGE_MANAGER="brew"
else
	echo "### Unknown operating system"
	exit 1
fi


if [[ $(id -u) -ne 0 ]] ; then 
	echo -e "\n### Not running as root at the moment, you may be asked to enter your password when installing packages\n"
fi
echo Updating package repositories
$OS_PACKAGE_MANAGER update

if ! which realpath > /dev/null; then
	echo "Installing Realpath"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS coreutils 1>/dev/null
fi
if ! which zopfli > /dev/null; then
	echo "Installing Zopfli"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS zopfli 1>/dev/null
fi
if ! which brotli > /dev/null; then
	echo "Installing Brotli"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS brotli 1>/dev/null
fi
if ! which gifsicle > /dev/null; then
	echo "Installing Gifsicle"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS gifsicle 1>/dev/null
fi
if ! which jpegoptim > /dev/null; then
	echo "Installing Jpegoptim"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS jpegoptim 1>/dev/null
fi
if ! which optipng > /dev/null; then
	echo "Installing Optipng"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS optipng 1>/dev/null
fi
if ! which MP4Box > /dev/null; then
	echo "Installing MP4Box"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS gpac 1>/dev/null
fi
if ! which ffmpeg > /dev/null; then
	echo "Installing FFmpeg"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS ffmpeg 1>/dev/null
fi
if ! ffmpeg -h 2>&1 | grep -o "enable-libaom" > /dev/null; then
	read -p "Doesn't look like this version of ffmpeg has libaom enabled, if you want to be able to do AV1 video encoding please try and find one that does, or build your own with the --enable-libaom option (enter to continue)"
fi


if ! which svgcleaner > /dev/null; then
if ! which cargo > /dev/null; then
	echo "Installing cargo"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS cargo
fi
	echo "Installing svgcleaner"
	cargo install svgcleaner

	if ! echo $PATH | grep -o ".cargo/bin" > /dev/null; then
		echo -e "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" | tee -a ~/.bashrc
		source ~/.profile
	fi
fi


if ! which cwebp > /dev/null; then
	echo "Installing cwebp"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS libjpeg-dev libpng-dev libtiff-dev libgif-dev 1>/dev/null
	
	wget -q https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz
	tar xzf libwebp-1.1.0.tar.gz
	cd libwebp-1.1.0
	./configure -q --enable-shared=false
	make -j$(grep -c ^processor /proc/cpuinfo) > /dev/null 2>&1
	sudo make install > /dev/null 2>&1
	cd ..
	rm -r libwebp-1.1.0*
fi


if ! which terser > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	echo "Installing terser"
	sudo npm install terser -g 1>/dev/null
fi


if ! which cleancss > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	echo "Installing cleancss"
	sudo npm install clean-css-cli -g 1>/dev/null
fi


if ! which html-minifier-terser > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	echo "Installing html-minifier"
	sudo npm install html-minifier-terser -g 1>/dev/null
fi

echo "Dependencies up-to-date"
