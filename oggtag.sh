#! /bin/bash

for song in *.ogg
do
  num=$(ogginfo "$song" | grep TRACKNUMBER | sed 's/.*TRACKNUMBER=//')
  title=$(ogginfo "$song" | grep TITLE | sed 's/.*TITLE=//')
  newtitle="$num"\ -\ "$title"
  mv "$song" "$newtitle.ogg"
done
