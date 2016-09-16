#!/bin/bash
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2015
#
# Publish the given file on the given port
#
set -e

f=""
t=1
port=8080
N='^[0-9]+$'
verbose=0

usage() {
  echo -e "Usage: $0 [OPTIONS] FILE"
  echo -e "\t-p, --port=PORT	Publish file on PORT [Default: 8080]"
  echo -e "\t-t, --times=N	Publish file N times [Default: 1]"
  echo -e "\t			\"0\" means infinite times"
  echo -e "\t-v, --verbose	Print client data"
  echo -e "\t-h,--help		Display this help text"
  echo -e "\nMandatory arguments to long options are also mandatory for any corresponding short options."
  echo -e "\nReport bugs to\tf.bonazzi@davide.it"
}

ARGS=`getopt -o 'p:t:vh' --long 'port:,times:,verbose,help' -n "$0" -- "$@"`

#Bad arguments
if [ $? -ne 0 ]
then
  exit 1
fi

eval set -- "$ARGS"

while :
do
  case $1 in
    -p | --port )
      if [[ "$2" =~ $N ]]
      then
        port="$2"
      else
        echo -e "Bad port \"$2\". Using default [$port]"
      fi
      shift 2
    ;;
    -t | --times )
      if [[ "$2" =~ $N ]]
      then
        t="$2"
      else
        echo -e "Bad times \"$2\". Using default [$t]"
      fi
      shift 2
    ;;
    -v | --verbose)
      verbose=1
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

if [[ -n "$@" && -f "$@" ]]
then
  f="$@"
else
  echo -e "Bad file \"$@\". Exiting..."
  exit 1
fi


if host $(hostname --fqdn) 2>&1 > /dev/null
then
  ip="$(hostname --fqdn)"
else
  ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
fi

echo -e "Publishing \"$f\" on:"
read -r -a lines <<< "$ip"
for line in "${lines[@]}"
do
	echo -e "\t$line:$port"
done

if [ "$t" -eq 0 ]
then
	while :
	do
		if [ "$verbose" -eq 1 ]
		then
			cat <(echo -e 'HTTP/1.1 200 OK\r\n') "$f" | nc -v -l "$port"
		else
			cat <(echo -e 'HTTP/1.1 200 OK\r\n') "$f" | nc -v -l "$port" >/dev/null
		fi
	done
else
	while [[ "$t" -gt 0 ]]
	do
		if [ "$verbose" -eq 1 ]
		then
			cat <(echo -e 'HTTP/1.1 200 OK\r\n') "$f" | nc -v -l "$port"
		else
			cat <(echo -e 'HTTP/1.1 200 OK\r\n') "$f" | nc -v -l "$port" >/dev/null
		fi
		(( t-- ))
	done
fi
