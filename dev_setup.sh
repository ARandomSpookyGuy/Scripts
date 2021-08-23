#! /bin/sh

#Add clear screen to xdotool

front_type(){
	echo -ne '
1).Website
2).React
3).React Native

Choice: ' ; read choice2

	case $choice2 in 
		1)
			holder='website';;
		2)	
			holder='react';;
		3)
			holder='react-native';;
		*) 
			echo "Choice not available";;
	esac


	if [[ $holder = 'website' ]]; then
		cmd1="npm"
		cmd2="start"
	elif [[ $holder = 'react' ]] ; then
		echo "React Project"
	elif [[ $holder = 'react-native' ]];then
		echo "React-Native Project"
	fi
}


set_up(){
        position=0
	holder=''
	cmd1=''
	cmd2=''

        for folder in ~/dev/* ; do
	
                position=$((position+1))
	folders=$(ls -dl $folder | awk '{print $1}')

	if [[ ${folders:0:1} == 'd' ]] ; then

		echo -e "$position).${folder:20}"
	fi
        done

        echo -ne "\nChoice: "; read choice

	front_type


	position=0

	for folder in ~/dev/* ; do
		position=$((position+1))
		if [ $choice == $position ] ; then

		#Container
		xdotool key super+g sleep 2 type "$(printf 'cd %s/front\r' $folder)"
		xdotool sleep 2 key ctrl+l type "$(printf '%s %s\r' $cmd1 $cmd2)"
		xdotool key ctrl+shift+Return sleep 2 key ctrl+l type "$(printf 'cd %s/docker\rdc run --rm server bash\r' $folder)"
		xdotool sleep 2 type "$(printf 'npm start\r')"
		xdotool sleep 2	key super+shift+3 

		##Editors
		xdotool key super+g sleep 2 type "$(printf 'cd %s/front\rnvim' $folder)" 
		xdotool sleep 2 key ctrl+shift+Return sleep 2 type "$(printf 'cd %s/docker\rdc run --rm server bash\r' $folder)"
		xdotool sleep 2 type "$(printf 'nvim')"
		xdotool sleep 2 key super+shift+2 

		fi
	done
}

set_up

