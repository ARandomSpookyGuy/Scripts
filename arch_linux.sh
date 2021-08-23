#! /bin/sh

#Variables######################################

#packages

pacakges_misc="
wget
man  
git 
ttf-fira-code 
firefox
bc
feh  
"

pacakges_sound_backlight="
acpilight 
alsa-utils 
"

packages_video="
xf86-video-amdgpu 
mesa 
mesa-vdpau 
libva-mesa-driver 
radeontop 
"

packages_filemanager="
ranger 
ueberzug 
"


packages_x="
xdotool 
xorg-xinput
xorg-server 
xorg-xsetroot 
xorg-xinit 
"

packages_polybar="
jsoncpp
cmake
xcb-util-image
xcb-util-wm
xcb-util-xrm
xcb-util-cursor
"

packages_pywal="
python 
python-pip 
python-pywal 
"
packages_fonts="
ttf-font-awesome-4 
nerd-fonts-iosevka 
ttf-nerd-fonts-symbols
"

rootname="ghost"
pass='si6737242'
username='ghostuser'
userpass='si6737242'

country="China"

img_url="https://w.wallhaven.cc/full/72/wallhaven-72w5pv.png"
##############################################

#VPN 

vpn(){
	vpn=$(pacman -Q | awk '/expressvpn/ {print $1}')
	connected=$(expressvpn status | awk '/If/ {print $2}')

	if [ $vpn = 'expressvpn' ] ;then
		if [ $connected = 'If' ]; then
			echo ''
		else
			echo "Vpn not connected."
			exit
		fi
	else
		echo ExpressVpn  not found.
		exit
	fi

}

aur(){
  if [[ $(pacman -Qq | grep paru) == "paru" ]]; then echo "Aur Helper found"; else echo 'No Aur Helper!'; exit ;fi
}

#Base Installation 

base(){
	#Misc

	reflector --country $country --save /etc/pacman.d/mirrorlist
	hwclock --systohc
	ln -sf /usr/share/zoneinfo/Asia/Harbin /etc/localtime
	sed -i -e '177s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen 
	locale-gen 
	echo "LANG=en_US.UTF-8" > /etc/locale.conf

	#Host File
	echo $rootname > /etc/hostname 
	echo -e "127.0.0.1	localhost\n::1		localhost\n127.0.1.1	$rootname.localdomain	$rootname" > /etc/hosts

	#Root Packages
	pacman -S --noconfirm networkmanager \
		amd-ucode \
		grub \
		efibootmgr \
		openssh \
		base-devel 

	#Network

	systemctl enable NetworkManager 

	#GRUB

	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &&
	grub-mkconfig -o /boot/grub/grub.cfg

	#New User + Sudo Privilages
	( echo $pass ; echo $pass ) | passwd 
	useradd -mG wheel $username 
	( echo $userpass ; echo $userpass ) | passwd $username 
	sed -i -e '85s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers 
	echo -e "Base Installed.\n=>Exit\n=>umount -R /mnt"

}

#Post Installation

post_installtion(){
	
	#Packages
	sudo pacman -S --noconfirm $packages_video $pacakges_misc $packages_filemanager $pacakges_sound_backlight

	#Directories
	mkdir -p ~/downloads 
	#Git Config Files
	cd ~ 
	git clone https://github.com/ARandomSpookyGuy/scripts.git  
	git clone https://github.com/ARandomSpookyGuy/dotfiles.git 
	
	#Clean Up
	mv ~/dotfiles/.bashrc ~/dotfiles/.bash_profile ~/dotfiles/.xinitrc ~/dotfiles/.alias ~/ 
	sudo rm -r ~/dotfiles 

}

#Aur Help Paru

aur_helper(){
	cd ~/downloads
	git clone https://aur.archlinux.org/paru.git 
	cd paru
	makepkg -si 
	paru -S --noconfirm devour 
	
}

#Sound Card Patch

sound_patch(){
	sudo echo -e "defaults.pcm.card 1\ndefaults.ctl.card 1" > ~/.asoundrc
}

#Window Manager

window_manager(){
	if [[ -d ~/pictures/colorschemes ]] ; then echo "Directory found."; else mkdir -p ~/pictures/colorschemes/; fi
	
	if [[ -d ~/.config/polybar ]] ; then echo "Directory found."; else mkdir -p ~/.config/polybar; fi

	paru -S --noconfirm $pacakges_fonts 
	sudo pacman -S --noconfirm $packages_x $packages_pywal  

	cd ~/pictures/colorschemes
	wget $img_url
	wal -i ~/pictures/colorschemes/*

	cd ~/downloads
	gti clone https://github.com/mihirlad55/dwmipcpp.git
	git clone https://github.com/mihirlad55/polybar-dwm-module.git

	cd ~/downloads/dwmipcpp ; ./build.sh
	cd ~/downloads/polybar-dwm-module ; ./build.sh 
	
	cd ~
	git clone https://github.com/ARandomSpookyGuy/window-manager---DWM.git 

	mv ~/window-manager---DWM ~/suckless
	cd ~/suckless/tabbed ; sudo make clean install 
	#cd ~/suckless/dmenu ; sudo make clean install 
	cd ~/suckless/dwm ; sudo make clean install 
	cd ~/suckless/st-*; sudo make clean install 

	cd ~/.config/polybar/
	git clone https://github.com/ARandomSpookyGuy/polybar.git

	mv ~/.config/polybar/polybar/* ~/.config/polybar/ ; sudo rm -r ~/.config/polybar/polybar

}

#Editor - NVIM

editor(){
	sudo pacman -S --noconfirm cmake unzip ninja tree-sitter npm nodejs 

	cd ~/downloads
	git clone https://github.com/neovim/neovim.git 
	cd ~/downloads/neovim 

	make CMAKE_BUILD_TYPE=Release &&
	sudo make install 

	#Plugin Manager
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	#Conf files
	cd ~ 
	git clone https://github.com/ARandomSpookyGuy/nvim_.git 
	if [[ -d ~/.config/nvim ]] ; then echo 'exist'; else mkdir -p ~/.config/nvim; fi 
	cp ~/nvim_/* ~/.config/nvim/ 
	sudo rm -r ~/config 

	#Packages
	sudo pacman -S --noconfirm xclip  

	echo "
	=> Alias
	=> sudo pacman -S gvim 
	=> nvim +PlugInstall
	"

	}

#System Monitor - BPYTOP

sys_monitor(){
	#sudo pacman -S --noconfirm python-psutil
	#cd ~/downloads 
	#git clone https://github.com/aristocratos/bpytop.git 
	#cd ~/downloads/bpytop/ 
	#sudo make install 

	if [[ ~/scripts/bpytop_pywal.sh ]] ; then echo "Color Scheme script available. Apply[(Yes)/No]?"; read answer; fi

	case $answer in 
		"yes")	~/scripts/bpytop_pywal.sh ;;
		"no") 	exit ;;
		*) 	~/scripts/bpytop_pywal.sh ;;
	esac
}

#Web Development - Docker 

web_dev(){
	sudo pacman -S --noconfirm docker docker-compose 
	cd ~/downloads

	paru -S mongodb-compass insomnia-bin

	mkdir -p ~/dev
}

#Reset package manager to base installation

reset(){

	if [[ $(whoami) != 'root' ]]; then
		echo "User is not root!"
		exit;
	fi

	#Remove Packages
	pacman -D --asdeps $(pacman -Qqe)
	pacman -D --asexplicit base linux linux-firmware 
	pacman -Rns --noconfirm $(pacman -Qttdq)

	#Grub 
	pacman -S grub efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &&
	grub-mkconfig -o /boot/grub/grub.cfg
	
	#Base Packages
	pacman -S --noconfirm networkmanager base-devel libnsl openssh 

	#sudo
	usermod -aG wheel $username 
	sed -i -e '85s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers 

	#Network
	systemctl enable NetworkManager

	#ssh
	systemctl enable sshd

	#Reflector - Pacman Mirror-List
	reflector --country $country --save /etc/pacman.d/mirrorlist

	reboot
}

#########################################

#Options

reset_arch(){
	echo '
	Options:
	1). Reset 
	2). Packages - Pacman
	' ; read reset_option

	case $reset_option in 
		"1")
			reset;;
		"2")
			user_packages;;
		"*")
			echo "Invalid option";;
	esac

}


##################################################

echo '
	Options:
	1).Root => /mnt
	2).User => Post Installation (VPN)
	3).Aur Helper => Paru (VPN)
	4).Patch Sound (VPN)
	5).Window Manager => DWM (VPN)
	6).System Monitor => BPYTOP (VPN)
	7).Editor => Nvim (VPN)
	8).Web Development => Docker (VPN)
	9).Reset Arch 


' ; read choice

case $choice in
	"1") 
		base 
		;;
	"2")
		vpn &&
		post_installtion 
		;;
	"3")
		vpn &&
		aur_helper
		;;
	"4")
		sound_patch 
		;;
	"5")
		vpn &&
		aur &&
		window_manager	
		;;
	"6")
		vpn &&
		aur &&
		sys_monitor
		;;

	"7")
		vpn &&
		aur &&
		editor	
		;;
	"8")
		#vpn && 
		aur &&
		web_dev
		;;
	"9")
		reset_arch		
		;;

	*)
		echo 'Choice not available.'
esac


