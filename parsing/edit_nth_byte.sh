#!/bin/sh
#
# Edit the n-th byte of a file with a given file, without using xxd

xxdrp () {
  if which xxd > /dev/null
  then
    echo -n "$1" | xxd -r -p
  else
    echo -ne `echo -n "$1" | sed 's/\([0-9a-fA-F]\{2\}\)/\\\x\1/g'`
  fi
}
xxdp () {
  if which xxd > /dev/null
  then
    xxd -p "$1"
  else
    hexdump -ve '/1 "%02X"' "$1"
  fi
}

usage() {
  echo "Usage: $0 [OPTIONS] FILE"
  echo -e "\t-i\t--index\t\tModify the byte at INDEX [Default: \"0\"]"
  echo -e "\t-v\t--value\t\tSpecify the modified byte value as a hexadecimal string [Default: increase by 1]"
  echo -e "\t-o\t--out\t\tName of the output file [Default: overwrite input file in place]"
  echo -e "\n\t-h\t--help\t\tPrint this help text and exit"
}

###############################################################################
# Parameters
FILE=""
OUTPUT=""
INDEX="0"
VALUE=""
###############################################################################
# Parse arguments
ARGS=`getopt -o 'i:v:o:h' --long 'index:,value:,out:,help' -n "$0" -- "$@"`

#Bad arguments
if [ $? -ne 0 ]
then
  usage
  exit -1
fi

while true
do
  case $1 in
    -i | --index )
      INDEX="$2"
      shift 2
      ;;
    -v | --value )
      VALUE="`echo $2 | cut -c1-2`"
      shift 2
      ;;
    -o | --out )
      OUTPUT="$2"
      shift 2
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
###############################################################################

if [ -z "$@" ]
then
  echo "Missing FILE!"
  usage
  exit 1
else
  FILE="$1"
fi

FILE_LEN=`wc -c $FILE | cut -d' ' -f1`
if [ "$INDEX" -gt "$FILE_LEN" ]
then
  echo "Index out of bounds (INDEX=$INDEX, $FILE is ${FILE_LEN}B"
  usage
  exit 1
fi

# Overwrite input file if not otherwise specified
if [ -z "$OUTPUT" ]
then
  OUTPUT="$FILE"
fi

# Increment the existing value if not otherwise specified
if [ -z "$VALUE" ]
then
  EXISTING_VALUE="0x`xxdp "$FILE" | cut -c$((2*$INDEX+1)),$((2*$INDEX+2))`"
  VALUE=`printf "%02X" $(($EXISTING_VALUE+1))`
fi

TMPOUT="`mktemp`"

xxdrp `xxdp "$FILE" | sed "s/../$VALUE/$(($INDEX+1))"` > "$TMPOUT"

cat "$TMPOUT" > "$OUTPUT"
rm "$TMPOUT"
