#!/bin/bash
# Written by Filippo Bonazzi
#
# Rename flac files passed as parameters according to their tag information
# in the format %n - %t.flac
#
# Get split FLAC files with
# $ cuebreakpoints $FILE.cue | shnsplit -o flac $FILE.flac
# $ cuetag $FILE.cue split-track*.flac
# Then run
# $ $0 split-track*.flac
#
DEBUG=false

for a in "$@"
do
	#ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
	TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
	TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
	newname="`printf %02g $TRACKNUMBER` - $TITLE.flac"
	newname=$(echo $newname | sed 's/[\/\\]/ - /g')
	echo "$a renamed to $newname"
	if ! $DEBUG
	then
		mv "$a" "$newname"
	fi
done
