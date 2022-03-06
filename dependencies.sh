#!/bin/bash
# set -x
set -e


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
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS coreutils
fi
if ! which zopfli > /dev/null; then
	echo "Installing Zopfli"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS zopfli
fi
if ! which brotli > /dev/null; then
	echo "Installing Brotli"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS brotli
fi
if ! which gifsicle > /dev/null; then
	echo "Installing Gifsicle"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS gifsicle
fi
if ! which jpegoptim > /dev/null; then
	echo "Installing Jpegoptim"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS jpegoptim
fi
if ! which optipng > /dev/null; then
	echo "Installing Optipng"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS optipng
fi
if ! which MP4Box > /dev/null; then
	echo "Installing MP4Box"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS gpac
fi
if ! which ffmpeg > /dev/null; then
	echo "Installing FFmpeg"
	./ffmpeg_compile.sh "$OS_PACKAGE_MANAGER" "$OS_PACKAGE_MANAGER_FLAGS"
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
		hash -r
		source ~/.profile
	fi
fi


if ! which cwebp > /dev/null; then
	echo "Installing cwebp"
	./webp_compile.sh "$OS_PACKAGE_MANAGER" "$OS_PACKAGE_MANAGER_FLAGS"
fi


if ! which terser > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh
fi
	echo "Installing terser"
	sudo npm install terser -g
fi


if ! which cleancss > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh
fi
	echo "Installing cleancss"
	sudo npm install clean-css-cli -g
fi


if ! which html-minifier-terser > /dev/null; then
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh
fi
	echo "Installing html-minifier"
	sudo npm install html-minifier-terser -g
fi

echo "Dependencies up-to-date"
