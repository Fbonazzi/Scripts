#!/usr/bin/env python
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2018
#
# Decode a binary string into its components

from __future__ import print_function
import sys
import argparse
import string

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

    print("{}:\t({} B)".format(label,len(b)))

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
        description=u"Decode a binary string into its components")
# An input string is required
parser.add_argument(u"STRING", help=u"The input string")
parser.add_argument(u"-e", u"--encode", action='store_true', default=False,
        help=u"Encode a string from the components")
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

if args.encode:
    s = args.STRING.replace(".", " ")
    l = s.split()
    if len(l) == 3:
        b = bytearray(2)
        b[0] = int(l[0]) << 3
        b[0] |= int(l[1]) & 0x07
        b[1] = int(l[2])
        print_bytes("String", b, args)
    else:
        print("Malformed components string: {}".format(args.STRING))
else:
    if args.STRING.startswith("0x"):
        s = args.STRING[len("0x"):]
    else:
        s = args.STRING
    if len(s) %2 == 1:
        s = "0" + s
    if all(c in string.hexdigits for c in s):
        value = bytearray.fromhex(s)
        print_bytes("String", value, args)
        field1 = value[0] >> 3
        field2 = value[0] & 0x07
        field3 = value[1]
        print("field1: {}".format(field1))
        print("field2: {}".format(field2))
        print("field3: {}".format(field3))
        #print_bytes("\tfield1", [field1], args, "\t")
        #print_bytes("\tfield2", [field2], args, "\t")
        #print_bytes("\tfield3", [field3], args, "\t")
    else:
        print("Malformed string: {}".format(args.STRING))
