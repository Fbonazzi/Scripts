#!/bin/bash
# Written by Filippo Bonazzi <f.bonazzi@davide.it>
#
# Add the track number to mp3 files passed as parameters to obtain the format:
#
# "## - Title.mp3"
#
##############################################################################

set -e

verbose=1
action=1
undo=0

usage() {
  echo -e "Usage: $0 [OPTIONS] FILES"
  echo -e "\t-n, --no-act \tNo action: show what files would have been renamed"
  echo -e "\t-s, --silent \tSilently rename files"
  echo -e "\t-u, --undo   \tRemove the leading '## - ' string from filenames"
  echo -e "\t-h, --help   \tDisplay this help text"
  echo -e "\nMandatory arguments to long options are also mandatory for any corresponding short options."
  echo -e "\nReport bugs to\tf.bonazzi@davide.it"
}

ARGS=`getopt -o 'nsuh' --long 'no-act,silent,undo,help' -n "$0" -- "$@"`

#Bad arguments
if [ $? -ne 0 ]
then
  exit 1
fi

eval set -- "$ARGS"

while :
do
  case $1 in
    -n | --no-act)
      action=0
      shift
    ;;
    -u | --undo)
      undo=1
      shift
    ;;
    -s | --silent)
      verbose=0
      shift
    ;;
    -h | --help )
      usage
      exit 0
    ;;
    -- )
      shift
      break
    ;;
    -* )
      echo "$0: error - unrecognized option $1" 1>&2
      usage
      exit 1
    ;;
    * )
      break
    ;;
  esac
done

# if [[ -n "$@" && -f "$@" ]]
# then
#   f="$@"
# else
#   echo -e "Bad file \"$@\". Exiting..."
#   exit 1
# fi
#

for track in "$@"
do
  # Check that the file is an mp3 track
  # Would be better to check with 'file' but ain't nobody got time for that...
  if [ "${track##*.}" != "mp3" ]
  then
    if [ "$verbose" -ne 0 ]
    then
      echo -e "Bad file \"$track\", skipping..."
    fi
    continue
  fi

  # Perform the direct or inverse renaming action
  if [ "$undo" -eq 0 ]
  then
    # Prepend the track number
    num=$(mp3info -p "%n" "$track")
    newname="$(printf "%02d - %s" "$num" "$track")"
    if [ "$verbose" -ne 0 ]
    then
      echo "$track renamed as $newname"
    fi
    if [ "$action" -ne 0 ]
    then
      mv "$track" "$newname"
    fi
  else
    # Remove the leading number string
    if [ "$verbose" -ne 0 ]
    then
      rename -v 's/^[0-9]+\ -\ //' "$track"
    else
      rename 's/^[0-9]+\ -\ //' "$track"
    fi
  fi

done
