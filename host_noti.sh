#! /bin/bash
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it>
#
# This script checks the provided MAC address against a list of
# known MAC addresses to find out the owner.

#mac_list=/path/to/your/mac/list/file
mac_list="/home/filippo/Documenti/mac_list"

# Check parameters
if [ $# -ne 1 ]
then
	echo "Usage: $0 <mac address>"
	exit 1
fi

grep "$1" $mac_list
