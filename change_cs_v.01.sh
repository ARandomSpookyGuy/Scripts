#! /bin/sh

#To restart dwm without killing startx
#Add this to your .xintrc:
#################
# while dwm; do #   
#    sleep 1    #
# done	        #
#################

#########################################
bpytop=$HOME/downloads/bpytop/ 
cs=$HOME/.cache/wal/colors-wal-dwm.h
suckless=$HOME/suckless
image_path=''
position=0
#########################################

get_pictures () {
for pictures in ~/pictures/colorschemes/*
	do
		position=$((position+1))
		echo "$position $pictures"
	done
	echo -n "Choice: "
	read choice

	position=0
	for pictures in ~/pictures/colorschemes/* ; do
		position=$((position+1))
		if [ $position == $choice ] ; then
			image_path=$pictures
		fi
	done
	echo Please wait while your color scheme is updated...
}

set_cs(){
	wal -i $image_path > /dev/null 
	sed -i '17d' $cs 
	sed -i -e '15s/norm_fg/sel_bg/g' -e '15s/norm_border/sel_bg/g' -e '16s/sel_fg/norm_fg/g' -e '16s/sel_bg/norm_bg/g' -e '16s/sel_border/sel_bg/g'  $cs 
}

remake_file() {
	sudo make clean install -sC $suckless/dwm*/ > /dev/null 2>&1 
	sudo make clean install -sC $suckless/st-*/ > /dev/null 2>&1 
	#sudo make clean install -sC $suckless/tabbed*/ > /dev/null
	xrdb -query -all > ~/.Xresources
}

update_bpytop(){
	 colors_new=$(grep -e 'char sel_bg' -e 'char sel_fg' -e 'char norm_border' ~/.cache/wal/colors-wal-dwm.h | awk '{print $4 $5 $6}' | sed -e 's/norm_border\[]/color8/g' -e 's/sel_bg\[]/color1/g' -e 's/sel_fg\[]/color15/g')

	sed -i -e 2d -e "3i $(echo ${colors_new})" $bpytop/bpytop_colors.py 
	make install -C ~/downloads/bpytop/ 
	echo bpytop theme updated...

 }

update_image(){
	echo $image_path
	feh --bg-fill $image_path
}


restart_dwm(){
	pkill dwm 	
}


colorscheme(){
	clear;
	T='...'   # The test text
	for FGs in '    m' '   1m' '  30m' '1;90m' '  31m' '1;91m' '  32m' \
           '1;92m' '  33m' '1;93m' '  34m' '1;94m' '  35m' '1;95m' \
           '  36m' '1;96m' '  37m' '1;97m';
	  do FG=${FGs// /}
	   for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
	    do echo -en "$EINS \033[$FG\033[$BG $T \033[0m";
	    done
  		echo;
	  done
	echo

}


#########################################

get_pictures &&
set_cs &&
remake_file &&
update_bpytop &&
update_image &&
restart_dwm &&
colorscheme



