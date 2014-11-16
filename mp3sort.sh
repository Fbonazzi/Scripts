#! /bin/bash

find . -maxdepth 1 -type f | while read track
do
	artist=$(mp3info -p %a "$track")
	album=$(mp3info -p %l "$track")
	#echo "./$artist/$album/"
	mkdir -p ./"$artist/$album/"
	mv "$track" ./"$artist/$album/"
done
