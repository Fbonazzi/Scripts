#!/bin/bash

for a in *.flac
do
	#ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
	TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
	TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
	mv "$a" "`printf %02g $TRACKNUMBER` - $TITLE.flac"
done
