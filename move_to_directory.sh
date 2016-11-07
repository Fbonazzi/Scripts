#!/bin/bash

for i in "$@"
do
	extension="${i##*.}"
	filename="${i%.*}"
	if [[ "$extension" =~ ^(mp4|avi|mkv)$ ]]
	then
		echo "Moving \"$i\" to \"$filename/$i\""
		mkdir "$filename"
		mv "$i" "$filename"
	else
		echo "Unsupported file \"$i\""
		continue
	fi
done
