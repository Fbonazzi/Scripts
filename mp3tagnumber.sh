#! /bin/bash

for track in *.mp3
do
	num=$(mp3info -p %n "$track")
	newname=$(echo "$num"' - '"$track")
	mv "$track" "$newname"
done
