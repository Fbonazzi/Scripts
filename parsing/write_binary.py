#!/usr/bin/env python3
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2018
#
# Writa a binary file given the description of its fields

from __future__ import print_function
from collections import namedtuple
import sys
import argparse
import struct

group_size = 8
structfields = ["Field1", "Field2", "FieldN"]
structfmt = '={}'.format("{}s".format(group_size) * len(structfields))
tuple_t = namedtuple('Name', " ".join(structfields))


def empty_file(args):
    a = bytearray(group_size * len(structfields))
    return tuple_t._make(struct.unpack(structfmt, a))


def print_file(file_tuple, args):
    for name, value in file_tuple._asdict().items():
        print_bytes(name, value, args)


def read_file(args):
    if args.input_file:
        with open(args.input_file, "rb") as f:
            a = bytearray(f.read())
    else:
        a = bytearray(group_size * len(structfields))

    return tuple_t._make(struct.unpack(structfmt, a))


def write_file(file_tuple, args):
    if args.showfile:
        print_file(file_tuple, args)

    file_bytes = struct.pack(structfmt, *file_tuple)

    # If file out then write to file, otherwise hexdump
    if args.output_file:
        with open(args.output_file, "wb") as f:
            f.write(file_bytes)
    else:
        print_bytes("File bytes", file_bytes, args)


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
    description=u"Write a binary file according to the description of its fields")
# The input file name
parser.add_argument(u"-i", u"--in", dest="input_file",
                    default=None, help=u"The input file")
# The output file name
parser.add_argument(u"-o", u"--out", dest="output_file",
                    default=None, help=u"The output file")
# File modification commands
parser.add_argument(u"--setgroup", action="append", nargs="+",
                    help=u"Set a group value to a byte array [e.g. \"--setgroup Field1=0x0102030405060708\"]")
# Show file after changes
parser.add_argument(u"--showfile", action='store_true', default=False,
                    help=u"Pretty-print the file after setting requested group values (if any)")

# Printing options
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

# Read the file
p = read_file(args)

# Write the requested file groups
if args.setfile:
    # Normalize the arguments
    l = " ".join([" ".join(x) for x in args.setfile]).split()
    write_groups = []
    # Check validity of each argument
    for x in l:
        # Check that the argument is in the format LHS=RHS
        if "=" not in x:
            print("Invalid argument \"{}\", ignoring it...".format(x))
            continue
        # Check that the LHS is one of the valid groups
        lhs = x[:x.index("=")]
        if lhs not in structfields:
            print("Invalid argument \"{}\", ignoring it...".format(x))
            continue
        # Check that the argument is a valid byte array
        # Lowercase (support both upper and lower case hex notation)
        rhs = x[x.index("=")+1:].lower()
        # Strip leading "0x" if any
        if (rhs.startswith("0x")):
            rhs = rhs[2:]
        # Check string content
        if rhs != "".join([c for c in rhs if c in "0123456789abcdef"]):
            print("Invalid argument \"{}\", ignoring it...".format(x))
            continue
        # Check that the byte array is group_size Bytes long (each byte
        # is 2 hexadecimal characters)
        if len(rhs) != 2*group_size:
            print("Invalid argument \"{}\", ignoring it...".format(x))
            continue

        write_groups.append((lhs, rhs))

    if write_groups:
        d = p._asdict()
        # Process each argument
        for lhs, rhs in write_groups:
            d[lhs] = bytearray.fromhex(rhs)
        p = tuple_t(**d)

    else:
        print("No valid arguments for --set option! No file changes made")

# Finally, write the file
write_file(p, args)
