#!/bin/bash

# Path to the backup directory
path="$HOME/Documenti/backup/video"
# Filename for the backup
file="film_$(date +%Y%m%d%H%M)"
# Path to the movie directory
movies="/media/filippo/Elements/Videos"
# Directories to be ignored ["dir1|dir2|dir3"]
ignoredir="YouTube|visti"

# Check if tree is installed
command -v tree >/dev/null 2>&1 || { echo >&2 "This program requires 'tree' but the software is not installed. Aborting."; exit 1; }

echo "Da vedere:" > "${path}/$file"
tree -I "$ignoredir" "$movies" >> "${path}/$file"

echo "Visti:" >> "${path}/$file"
tree "${movies}/visti" >> "${path}/$file"

cd "$path"

old=$(readlink film_latest)

ln -f -s -T $file film_latest

cmp -s $old $file

if [[ "$?" -eq "0" ]]
then
  if [[ "$file" != "$old" ]]
  then
    rm "$old"
  fi
  old=$(echo "$old" | sed -e's/.*film_//')
  echo "La lista non presenta modifiche dalla versione $old"
fi

# Synchronize with Dropbox
cp -rLu /home/filippo/Documenti/backup/video /home/filippo/Dropbox/Public/backup/
