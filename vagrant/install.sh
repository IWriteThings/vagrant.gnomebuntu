#!/usr/bin/env bash

echo "Installing!"
if [ ! -d "/root/.ssh/" ]; then
	mkdir /root/.ssh && touch /root/.ssh/known_hosts
fi

echo "Starting the upgrade process..."
sudo apt-get -y update > /dev/null
sudo apt-get -y upgrade > /dev/null
sudo apt-get -y dist-upgrade > /dev/null
echo "Upgrade complete!"

# Install Initial Software
echo "Installing software from the repositories..."
sudo apt-get -y install \
	guake \
	newsbeuter \
	rtorrent \
	cmus \
	figlet \
	curl \
	git \
	youtube-dl \
	xclip \
	htop \
	unzip \
	vim; > /dev/null

sudo apt-get -y install \
	build-essential \
	ruby \
	cmake \
	python-dev \
	automake \
	autoconf \
	pkg-config \
	libevent-1.4 \
	libevent-dev \
	libncurses5-dev \
	autotools-dev; > /dev/null
echo "Install complete!"

# tmux v2.0 installation steps for Ubuntu 14.04 (Trusty Tahr)
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository -y ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install -y tmux
tmux -V

# Download fonts
sudo git clone https://github.com/powerline/fonts.git /tmp/fonts && su -c "sh /tmp/fonts/install.sh" vagrant

## CPU LOAD
sudo git clone https://github.com/thewtex/tmux-mem-cpu-load.git /tmp/tmuxcpu
sudo sh -c "cd /tmp/tmuxcpu && sudo cmake . && sudo make && sudo make install";
# Plugin Manager for TMUX
git clone https://github.com/tmux-plugins/tpm /home/vagrant/.tmux/plugins/tpm
# Add hub to path
sudo curl https://hub.github.com/standalone -Lo /usr/bin/hub
sudo chmod 755 /usr/bin/hub

echo "Installing dotfiles!"
# dotfile time!
if [ ! -d "/home/vagrant/.dotfiles" ]; then
	git clone https://github.com/IWriteThings/dotfiles.git /home/vagrant/.dotfiles
	sudo chown -R vagrant:vagrant /home/vagrant/.dotfiles
	rm /home/vagrant/.bash*
	rm /home/vagrant/.profile
	ln -s /home/vagrant/.dotfiles/.bash* /home/vagrant/
	ln -s /home/vagrant/.dotfiles/.tmux.* /home/vagrant/
	ln -s /home/vagrant/.dotfiles/.dircolors /home/vagrant/
	ln -s /home/vagrant/.dotfiles/.profile /home/vagrant/
	ln -s /home/vagrant/.dotfiles/.vimrc /home/vagrant/
	ln -s /home/vagrant/.dotfiles/urls /home/vagrant/.newsbeuter/
	git clone https://github.com/VundleVim/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim
	tmux source /home/vagrant/.tmux.conf
	sudo chown -R vagrant:vagrant /home/vagrant/.vim
	# Install Vim plugins
	su -c "vim +PluginInstall +qall +silent" vagrant
	# Install YCM
	su -c "/home/vagrant/.vim/bundle/YouCompleteMe/install.py" vagrant
fi

# Remove any holds by root in vagrant home
sudo chown -R vagrant:vagrant /home/vagrant

## Autostart Guake on boot
sudo cp /usr/share/applications/guake.desktop /etc/xdg/autostart/
