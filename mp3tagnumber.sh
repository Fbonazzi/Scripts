#!/bin/bash
# Written by Filippo Bonazzi
#
# Add the track number mp3 files passed as parameters
DEBUG=true

for track in "$@"
do
  num=$(mp3info -p %n "$track")
  newname="$num - $track"
  echo "$track renamed to $newname"
  if ! $DEBUG
  then
    mv "$track" "$newname"
  fi
done
