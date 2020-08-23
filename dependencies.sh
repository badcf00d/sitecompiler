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


if [[ $(id -u) -ne 0 ]] ; then echo ; echo "### Not running as root at the moment, you may be asked to enter your password when installing packages"; fi
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
if ! which ffmpeg > /dev/null; then
	echo "Installing FFmpeg"
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS ffmpeg 1>/dev/null
fi
if ! ffmpeg -h 2>&1 | grep -o "enable-libaom" > /dev/null; then
	read -p "Doesn't look like this version of ffmpeg has libaom enabled, if you want to be able to do AV1 video encoding please try and find one that does, or build your own with the --enable-libaom option (enter to continue)"
fi


if ! which svgcleaner > /dev/null; then
	echo "Installing svgcleaner"
if ! which brew > /dev/null; then
	echo "Installing linuxbrew (This may take a minute or two)"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.profile
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
	brew install svgcleaner
fi


if ! which cwebp > /dev/null; then
	echo "Installing cwebp"
if ! which brew > /dev/null; then
	echo "Installing linuxbrew (This may take a minute or two)"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.profile
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
	brew install webp
fi


if ! which MP4Box > /dev/null; then
	echo "Installing MP4Box"
if ! which brew > /dev/null; then
	echo "Installing linuxbrew (This may take a minute or two)"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.profile
	eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
	brew install gpac
fi


if ! which terser > /dev/null; then
	echo "Installing terser"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install terser -g 1>/dev/null
fi


if ! which cleancss > /dev/null; then
	echo "Installing cleancss"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install clean-css-cli -g 1>/dev/null
fi


if ! which html-minifier-terser > /dev/null; then
	echo "Installing html-minifier"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	$OS_PACKAGE_MANAGER install $OS_PACKAGE_MANAGER_FLAGS nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install html-minifier-terser -g 1>/dev/null
fi

echo "Dependencies up-to-date"