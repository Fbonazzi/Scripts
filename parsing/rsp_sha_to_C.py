#!/usr/bin/env python
#
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2018
#
# Print a binary file as a string of bytes, formatted with the C byte syntax

from __future__ import print_function
import sys
import argparse

def print_C_bytes(s):
    # Lowercase (support both upper and lower case hex notation)
    s = s.lower()
    # Check string content
    for c in s:
        if c not in "0123456789abcdef":
            print("Bad string \"{}\"".format(s))
            sys.exit(1)
    # Right-align the string with zeroes to a multiple of 2
    if len(s) % 2:
        s = "0" + s
    # Generate an array of numbers
    arr = []
    for i in range(0, len(s), 2):
        arr.append(int("{}{}".format(s[i], s[i+1]), 16))
    i = 0
    if args.lowercase:
        for b in arr:
            if i and i % args.no_per_line == 0:
                print(",")
            if i and i % args.no_per_line != 0:
                print(", ", end="")
            print("{:#04x}".format(b), end="")
            i+=1
    else:
        for b in arr:
            if i and i % args.no_per_line == 0:
                print(",")
            if i and i % args.no_per_line != 0:
                print(", ", end="")
            print("{:#04X}, ".format(b), end="")
            i+=1
    print()

# Parse arguments
parser = argparse.ArgumentParser(
        description=u"Convert an .rsp file to C syntax")
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

with open(args.FILE, "r") as f:
    a = f.readlines()
# Strip whitespace
a = [l.strip() for l in a]
# Remove empty lines
a = [l for l in a if l]
# Remove comments
a = [l for l in a if not l.startswith("#")]
# Remove [
a = [l for l in a if not l.startswith("[")]

i = 0
for l, msg, md in zip(*[iter(a)]*3):
    print("// Message {}".format(i))
    i += 1
    # Write the length in bytes
    print("{{ {},".format(int(l[len("Len = "):])/8))
    # Write the digest
    print("{ ", end="");
    print_C_bytes(md[len("MD = "):])
    print("},");
    # Write the message
    print("{ ", end="");
    print_C_bytes(msg[len("Msg = "):])
    print("}\n},");


