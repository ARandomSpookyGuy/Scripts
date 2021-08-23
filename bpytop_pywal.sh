#! /bin/sh


###################################################

bpytop=$HOME/downloads/bpytop
#wal_temp=$HOME/downloads/pywal/pywal/templates
#link='/home/ghostuser/downloads/pywal/pywal/templates'
###################################################

create_template(){
	echo -e "from typing import Dict" > $bpytop/bpytop_colors.py
}

modify(){

	echo -e "color8='#ff'; color1='#ff'; color15='#ff'" >> $bpytop/bpytop_colors.py
	sed -n 271,314p $bpytop/bpytop.py >> $bpytop/bpytop_colors.py
	sed -ie 271,314d $bpytop/bpytop.py
	sed -i "271 i sys.path.append('$bpytop')\nimport bpytop_colors\nDEFAULT_THEME=bpytop_colors.DEFAULT_THEME" $bpytop/bpytop.py

}

set_colors(){
	 sed -i -e "5s/\"#cc\"/color15/g" \
		-e "6s/\"#ee\"/color1/g" \
		-e "7s/\"#969696\"/color8/g" \
		-e "8s/\"#7e2626\"/color8/g" \
		-e "9s/\"#ee\"/color1/g" \
		-e "10s/\"#40\"/color1/g" \
		-e "11s/\"#60\"/color1/g" \
		-e "12s/\"#40\"/color8/g" \
		-e "13s/\"#0de756\"/color1/g" \
		-e "14s/\"#3d7b46\"/color15/g" \
		-e "15s/\"#8a882e\"/color15/g" \
		-e "16s/\"#423ba5\"/color15/g" \
		-e "17s/\"#923535\"/color15/g" \
		-e "18s/\"#30\"/color15/g" \
		-e "19s/\"#4897d4\"/color1/g" \
		-e "20s/\"#5474e8\"/color15/g" \
		-e "21s/\"#ff40b6\"/color8/g"\
		-e "22s/\"#50f095\"/color1/g" \
		-e "23s/\"#f2e266\"/color15/g" \
		-e "24s/\"#fa1e1e\"/color8/g" \
		-e "25s/\"#223014\"/color1/g" \
		-e "26s/\"#b5e685\"/color15/g" \
		-e "27s/\"#dcff85\"/color8/g" \
		-e "28s/\"#0b1a29\"/color1/g" \
		-e "29s/\"#74e6fc\"/color15/g" \
		-e "30s/\"#26c5ff\"/color8/g" \
		-e "31s/\"#292107\"/color1/g" \
		-e "32s/\"#ffd77a\"/color15/g" \
		-e "33s/\"#ffb814\"/color8/g" \
		-e "34s/\"#3b1f1c\"/color1/g" \
		-e "35s/\"#d9626d\"/color15/g" \
		-e "36s/\"#ff4769\"/color8/g" \
		-e "37s/\"#231a63\"/color1/g" \
		-e "38s/\"#4f43a3\"/color15/g" \
		-e "39s/\"#b0a9de\"/color8/g" \
		-e "40s/\"#510554\"/color1/g" \
		-e "41s/\"#7d4180\"/color15/g" \
		-e "42s/\"#dcafde\"/color8/g" \
		-e "43s/\"#80d0a3\"/color1/g" \
		-e "44s/\"#dcd179\"/color15/g" \
		-e "45s/\"#d45454\"/color8/g" $bpytop/bpytop_colors.py
	}	

remake(){
	cd $bpytop &&
	make install
}
create_template &&
modify &&
set_colors &&
remake

