#!/bin/bash

if ! which apt-get > /dev/null; then
	echo "### You don't seem to have apt-get, so this probably isn't a debian-based system, feel free to make a pull request to add support"
	exit 1
fi

if [[ $(id -u) -ne 0 ]] ; then echo ; echo "### Not running as root at the moment, you may be asked to enter your password when installing packages"; fi
echo Updating package repositories
sudo apt-get update

if ! which zopfli > /dev/null; then
	echo "Installing Zopfli"
	sudo apt-get install -y zopfli 1>/dev/null
fi
if ! which brotli > /dev/null; then
	echo "Installing Brotli"
	sudo apt-get install -y brotli 1>/dev/null
fi
if ! which gifsicle > /dev/null; then
	echo "Installing Gifsicle"
	sudo apt-get install -y gifsicle 1>/dev/null
fi
if ! which jpegoptim > /dev/null; then
	echo "Installing Jpegoptim"
	sudo apt-get install -y jpegoptim 1>/dev/null
fi
if ! which optipng > /dev/null; then
	echo "Installing Optipng"
	sudo apt-get install -y optipng 1>/dev/null
fi
if ! which ffmpeg > /dev/null; then
	echo "Installing FFmpeg"
	sudo apt-get install -y ffmpeg 1>/dev/null
fi
if ! ffmpeg -h 2>&1 | grep -o "enable-libaom" > /dev/null; then
	echo "Doesn't look like that ffmpeg build has libaom enabled, please try and find one that does, or build your own"
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


if ! which uglifyjs > /dev/null; then
	echo "Installing uglify-js"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	sudo apt-get install -y nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install uglify-js -g 1>/dev/null
fi


if ! which cleancss > /dev/null; then
	echo "Installing cleancss"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	sudo apt-get install -y nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install clean-css-cli -g 1>/dev/null
fi


if ! which html-minifier > /dev/null; then
	echo "Installing html-minifier"
if ! which node > /dev/null; then
	echo "Installing node (This may take a minute or two)"
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - 1>/dev/null
	sudo apt-get install -y nodejs 1>/dev/null
fi
if ! which npm > /dev/null; then
	echo "Installing npm (This may take a minute or two)"
	curl -L https://npmjs.org/install.sh | sudo sh 1>/dev/null
fi
	sudo npm install html-minifier -g 1>/dev/null
fi

echo "Dependencies up-to-date"