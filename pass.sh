#!/bin/sh

folder=~/.password-store


user_stores(){
	for item in $(ls $folder);do
		count=$((count+1))
		echo "$count).$item"
	done

	echo -ne "\nChoice: "; read choice
}

user_pass(){
	count=0
	pre=0
	for item in $folder/* ;do
		count=$((count+1))
		if [[ $count == $choice ]]; then
			for item in $item/*/* ;do
				pre=$((pre+1))
				cut_password=$(echo $item | awk  -F' |/' '{print $5 "/" $6 "/" $7  $8}' )
				echo "$pre) $cut_password"
			done
		fi	
	done
	echo -ne "\nChoice: "; read choice2
}

copy_pass(){
	count=0
	pre=0
	for item in $folder/* ;do
		count=$((count+1))
		if [[ $count == $choice ]]; then
			for item in $item/*/* ;do
				pre=$((pre+1))
				if [[ $pre == $choice2 ]] ; then 
					cut_password=$(echo $item | awk  -F' |/' '{print $5 "/" $6 "/" $7  $8}' )
					output=$(echo ${cut_password//.gpg})
					pass -c $output  > /dev/null
					clear
				fi
			done
		fi	
	done
}

user_stores &&
user_pass &&
copy_pass



