#!/bin/sh

echo -e "File name: " ; read file_name


img_big=$file_name'_big.png'
img_small=$file_name'_small.png'

screenshots=~/pictures/screenshots
website=~/pictures/website


sleep 3;

ffmpeg -f x11grab -video_size 1920x1080 -i $DISPLAY -vframes 1 ~/pictures/screenshots/$file_name.png > /dev/null 2>&1 
ffmpeg -i $screenshots/$file_name.png -vf scale=1080x720 $website/$img_small > /dev/null 2>&1

mv $screenshots/$file_name.png $website/$img_big

