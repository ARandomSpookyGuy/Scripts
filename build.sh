#! /bin/sh

update_packages(){
	apt-get update &&
	apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
}

get_editor(){
	git clone https://github.com/neovim/neovim.git && 
	cd neovim && 
	make CMAKE_BUILD_TYPE=Release 
	make install 
}

get_plugin(){
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

update_packages &&
get_editor &&
get_plugin


