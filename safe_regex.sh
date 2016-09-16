#!/bin/bash
#
# Escape sensitive characters in text strings to make them "literal" for sed LHS
# Taken from http://backreference.org/2009/12/09/using-shell-variables-in-sed/

extended=1

# Change this, properly learn and implement getopts
if [ $# -eq 1 ]
then
  pattern=$1
elif [ $# -eq 2 ]
then
  extended=0	# True
  if [ "$1" == "extended" ]
  then
    pattern=$2
  elif [ "$2" == "extended" ]
  then
    pattern=$1
  else
    echo "Bad parameters: $1 $2"
    exit -1
  fi
else
  echo "Wrong number of parameters."
  echo -e "\n Usage: $0 'regex_unsafe' [extended]"
  exit -1
fi

if [ $extended ]
then
  safe_pattern=$(printf '%s\n' "$pattern" | sed 's/[[\.*^$(){}?+|/]/\\&/g')
else
  safe_pattern=$(printf '%s\n' "$pattern" | sed 's/[[\.*^$/]/\\&/g')
fi
printf '%s\n' "$safe_pattern"
exit 0
