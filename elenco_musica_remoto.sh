#! /bin/bash

# For debug add
#	echo "Siamo nella cartella"
#	pwd
#	read -p "Press [Enter] key..."

prefix=~/Documenti/backup/musica/
file="$prefix"musica_hdd"$(date +%Y%m%d%H%M)"

#Changes from version to version of SMB or GVFS, if script
#suddenly breaks check this line
cd /run/user/filippo/gvfs/smb-share\:server\=192.168.1.100\,share\=public/Shared\ Music/Musica\ Filippo/

find . -maxdepth 1 -mindepth 1 -type d | while read dir
do
  #	dir=$(echo "$dir" | sed 's/\///') #seems to be useless, don't know why it's here (201301141408)
  echo "$dir" | sed 's/^\.\///' >> $file
  cd "$dir/"
  find . -maxdepth 1 -mindepth 1 -type d | while read dir2
  do
    #		dir2=$(echo "$dir2" | sed 's/\///') #seems to be useless
    echo -n "	" >> $file
    echo "$dir2" | sed 's/^\.\///' >> $file
  done
  cd ..
  echo "" >> $file
done

cd $prefix

file=$(echo $file | sed -e "s/.*musica_hdd/musica_hdd/")
old=$(ls -la musica_hdd_latest | sed -e 's/.*-> //' | sed -e 's/.*musica/musica/')

ln -fs $file musica_hdd_latest
if [ -z $old ]
then
  echo "Prima esecuzione dello script!"
  exit
fi

cmp -s $old $file
if [[ "$?" -eq "0" ]]
then
  if [[ "$file" != "$old" ]]
  then
    rm $old
  fi
  old=$(echo "$old" | sed -e's/.*musica_hdd//')
  echo "La lista non presenta modifiche dalla versione $old"
fi
