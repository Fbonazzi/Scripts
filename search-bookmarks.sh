#!/bin/bash
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2014
#
# Search browser bookmarks from the CLI
#
set -e

#Setting sane defaults
output="all"						#Default output
bookmarks="$HOME/.config/chromium/Default/Bookmarks"	#Chromium bookmarks
search='*'						#Default search
case_sensitive=0					#Case sensitive [0 TRUE, 1 FALSE]
numbered_lines=1					#Numbered lines [0 TRUE, 1 FALSE]
DEBUG=1							#Debug [0 TRUE, 1 FALSE]

usage()
{
  echo -e "Usage: $0 [OPTIONS] \"string\"\n"

  echo -e "\t-i		Case insensitive search"
  echo -e "\t--numbers	Prepend line numbers to output\n"

  echo -e "\t-a, --all	Print all bookmark information [Default]"
  echo -e "\t-n, --name	Print bookmark name"
  echo -e "\t-u, --url	Print bookmark URL"
  echo -e "\n\t-h, --help	Print this help text"
  echo -e "\nSupported browsers: Chromium"
}

print_name()
{
  if [ $numbered_lines -eq 0 ] #True
  then
    cat $filename | sed -r 's/"name": "(.*)",.*/\1/' | nl
  else
    cat $filename | sed -r 's/"name": "(.*)",.*/\1/'
  fi
}

print_url()
{
  if [ $numbered_lines -eq 0 ] #True
  then
    cat $filename | sed -r 's/.*"url": "(.*)"/\1/' | nl
  else
    cat $filename | sed -r 's/.*"url": "(.*)"/\1/'
  fi
}

print_all()
{
  if [ $numbered_lines -eq 0 ] #True
  then
    cat $filename | nl | sed -r 's/"name": "(.*)", "url": "(.*)"/\1\n\t\t\2\n/'
  else
    cat $filename | sed -r 's/"name": "(.*)", "url": "(.*)"/\1\n\t\2\n/'
  fi
}

ARGS=`getopt -o 'ianuh' --long 'all,name,url,numbers,help' -n "$0" -- "$@"`

#Bad arguments
if [ $? -ne 0 ]
then
  usage
  exit -1
fi

output_selected=1 #false

while :
do
  case $1 in
    -i )
      case_sensitive=1 #False
      shift
    ;;
    -a | --all )
      if [ $output_selected -eq 1 ]
      then
        output="all"
        output_selected=0
      else
        echo "$0: conflicting option \"$1\""
        usage
        exit -1
      fi
      shift
    ;;
    -n | --name )
      if [ $output_selected -eq 1 ]
      then
        output="name"
        output_selected=0
      else
        echo "$0: conflicting option \"$1\""
        usage
        exit -1
      fi
      shift
    ;;
    -u | --url )
      if [ $output_selected -eq 1 ]
      then
        output="url"
        output_selected=0
      else
        echo "$0: conflicting option \"$1\""
        usage
        exit -1
      fi
      shift
    ;;
    --numbers )
      numbered_lines=0 #True
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
    -* )	# Should never get here; getopt should handle errors on its own
      echo "$0: unrecognized option \"$1\"" 1>&2
      usage
      exit -1
    ;;
    * )
      break
    ;;
  esac
done

if [ -n "$@" ]
then
  search="$@"
fi

if [ $DEBUG -eq 0 ]
then
  echo "Output richiesto: $output"
  echo "Stringa da cercare: \"$search\""
  echo "Case sensitive? $case_sensitive"
  echo "Linee numerate? $numbered_lines"
  echo ""
fi

filename=$(mktemp)

if [ $case_sensitive -eq 0 ] #True
then
  grep -B4 -A1 -i -E '"type": "url"' "$bookmarks" | grep -E '"name":|"url":' | sed -n '/^--.*/!p' | sed -r 's/\s+//' | paste -d " " - - | grep -e "\"name\": \".*${search}.*\"," -e "\"url\": \".*${search}.*\"" > "$filename"
elif [ $case_sensitive -eq 1 ] #False
then
  grep -B4 -A1 -i -E '"type": "url"' "$bookmarks" | grep -E '"name":|"url":' | sed -n '/^--.*/!p' | sed -r 's/\s+//' | paste -d " " - - | grep -i -e "\"name\": \".*${search}.*\"," -e "\"url\": \".*${search}.*\"" > "$filename"
fi

case $output in
  all )
    print_all
  ;;
  name )
    print_name
  ;;
  url )
    print_url
  ;;
esac

rm $filename
