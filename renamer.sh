#!/bin/bash

#Sostituto per 'rename' di Ubuntu, che su Arch è diverso

#Modificare la regex volta per volta
regex='s/([0-9]{2})([0-9]{2})([0-9]{2})(.*)/\3\2\1\4/g'

mkdir renamed

for name in "$@"
do
  newname=$(echo "$name" | sed -r "$regex")
  cp "$name" renamed/"$newname"
done
