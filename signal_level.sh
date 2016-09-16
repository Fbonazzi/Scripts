#! /bin/bash

#Default wireless interface
default_interface="wlan0"
#Default view without dBm
default_human=1

usage() {
  echo "Usage: $0 [OPTIONS] "
  echo ""
  echo -e "\t-i, --interface=INTERFACE	use the specified interface [Default: $default_interface]"
  echo -e "\t-h, --human-readable		display result in a human readable way (dBm)"
  echo -e "\t--help\t			display this help text"
  echo -e "\nMandatory arguments to long options are also mandatory for any corresponding short options."
  echo -e "\nReport bugs to\tf.bonazzi@davide.it"
}

ARGS=`getopt -o 'qi:h?' --long 'quiet,interface:,human-readable,help' -n "$0" -- "$@"`

#Bad arguments
if [ $? -ne 0 ]
then
  exit 1
fi

interface=$default_interface
human=$default_human
quiet=1

eval set -- "$ARGS"

while :
do
  case $1 in
    -i | --interface ) interface="$2"; shift 2;;
    -h | --human ) human=0; shift;;
    -q | --quiet ) quiet=0; shift;;
    --help ) usage; exit 0;;
    -- ) shift; break;;
    -* ) echo "$0: error - unrecognized option $1" 1>&2; usage; exit 1;;
    * ) break;;
  esac
done

tmp=`iwconfig $interface | grep "Signal level" | sed -e 's/.*Signal\ level=//'`

if [ $human -eq 1 ]
then
  tmp=`echo $tmp | sed -e 's/\ dBm.*//'`
fi

if [ $quiet -eq 1 ]
then
  echo $tmp
else
  exit $((-$tmp))
fi
