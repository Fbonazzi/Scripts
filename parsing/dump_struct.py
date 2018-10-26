#!/usr/bin/env python3
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2018
#
# Print a binary file with its struct description

from __future__ import print_function
from collections import namedtuple
import sys
import argparse
import struct


def print_bytes(label, b, args, line_prefix=""):
    width = 2
    if args.lowercase:
        case = "x"
    else:
        case = "X"
    if args.no_prefix:
        prefix = ""
    else:
        prefix = "#"
        width += 2
    if args.no_pad:
        pad = ""
    else:
        pad = "0"

    fmtstring = "{:" + prefix + pad + str(width) + case + "}"

    print("{}:\t({} B)".format(label, len(b)))

    i = 0
    for a in b:
        if i:
            if i % args.no_per_line == 0:
                print(args.separator.rstrip())
            else:
                print(args.separator, end="")
        if i % args.no_per_line == 0:
            print(line_prefix, end="")
        print(fmtstring.format(a), end="")
        i += 1
    print()


# Parse arguments
parser = argparse.ArgumentParser(
    description=u"Dump a binary file according to its C structure")
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
# Use a given separator string [Default: " "]
parser.add_argument(u"-s", u"--separator", type=str, default=" ",
                    help=u"Use a string as a separator [Default: \" \"]")
# Do not pad the hexadecimal number with leading zeroes [Default: False]
parser.add_argument(u"--no-pad", action='store_true', default=False,
                    help=u"Do not pad the hexadecimal number with leading zeroes")
# Do not print the hexadecimal 0x prefix [Default: False]
parser.add_argument(u"--no-prefix", action='store_true', default=False,
                    help=u"Do not print the hexadecimal 0x prefix")

args = parser.parse_args()

with open(args.FILE, "rb") as f:
    a = bytearray(f.read())

structfmt = '=2c2sc17sc2s5c2c42s2s32s32s'

Payload = namedtuple('Payload', 'Field1 Field2 FieldN')

p = Payload._make(struct.unpack(structfmt, a))

for name, value in p._asdict().items():
    print_bytes(name, value, args)
