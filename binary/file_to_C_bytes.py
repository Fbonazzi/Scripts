#!/usr/bin/env python
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2018
#
# Print a binary file as a string of bytes, formatted with the C byte syntax

from __future__ import print_function
import sys
import argparse

# Parse arguments
parser = argparse.ArgumentParser(
        description=u"Print a binary file as a string of bytes in C byte syntax")
# The file name is required
parser.add_argument(u"FILE", help=u"The input file")
# Print a given number of bytes per line [Default: 8]
parser.add_argument(u"-n", u"--no-per-line", type=int, default=8,
        help=u"Write n bytes per line [Default: 8]")
# Print bytes upper or lowercase
group_case = parser.add_mutually_exclusive_group(required=False)
group_case.add_argument(u"-l", u"--lowercase", action='store_true', default=True,
        help=u"Use lowercase hexadecimal characters [Default]")
group_case.add_argument(u"-u", u"--uppercase", action='store_false', dest='lowercase',
        help=u"Use uppercase hexadecimal characters")

args = parser.parse_args()

with open(args.FILE, "rb") as f:
    a = bytearray(f.read())

i = 0

if args.lowercase:
    fmtstring = "{:#04x}, "
else:
    fmtstring = "{:#04X}, "

for b in a:
    if i and i % args.no_per_line == 0:
        print()
    print(fmtstring.format(b), end="")
    i+=1

print()
