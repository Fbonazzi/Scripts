#! /bin/bash

# Path to the backup directory
path="$HOME/Documenti/backup/musica"
# Filename
file="musica_$(date +%Y%m%d%H%M)"
# Path to the music directory
music="/media/filippo/LG External HDD Drive/Music"

cd "$music"

for artist in */
do
	echo "$artist" >> "${path}/$file"
	cd "$artist/"
	for album in */
	do
		echo "	$album" >> "${path}/$file"
	done
	cd ..
	echo "" >> "${path}/$file"
done

cd "$path"

old=$(readlink musica_latest)

ln -f -s -T $file musica_latest

cmp -s $old $file

if [[ "$?" -eq "0" ]]
then
        if [[ "$file" != "$old" ]]
        then
                rm "$old"
        fi
        old=$(echo "$old" | sed -e's/.*musica_//')
        echo "La lista non presenta modifiche dalla versione $old"
fi

#This is to keep things synchronized with Dropbox for easier access
cp -rLu /home/filippo/Documenti/backup/musica /home/filippo/Dropbox/Public/backup/
