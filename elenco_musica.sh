#! /bin/bash

# Path to the backup directory (N.B. no terminating slash)
path="$HOME/Documents/backup/musica"
# Filename
file="musica_$(date +%Y%m%d%H%M)"
# Path to the music directory (N.B. no terminating slash)
music="/media/$USER/LG External HDD Drive/Music"

# Use tree if available
if command -v tree > /dev/null
then
	tree --noreport -dno "${path}/$file" "$music"
# Else use the piolet
else
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
fi

cd "$path"
# Save the latest list
old=$(readlink musica_latest)
# Link the new file as the latest
ln -f -s -T $file musica_latest

# If the new file and the previous are identical, report it
if cmp -s "$old" "$file"
then
	# If the file contents are identical but the names are different,
	# keep the most recent file and delete the oldest.
        if [[ "$file" != "$old" ]]
        then
                rm "$old"
        fi
	oldver=$(echo "$old" | sed -e's/.*musica_//')
        echo "La lista non presenta modifiche dalla versione $oldver"
fi

#This is to keep things synchronized with Dropbox for easier access
cp -rLu "$path" "$HOME/Dropbox/Public/backup/"
