#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert a byte string of arbitrary length (e.g. "34a3f217be") into its binary
# representation using the "LSB 0" numbering scheme.
# TODO: add argparse, support "MSB 0"
import sys

# Remove whitespace
s = "".join(sys.argv[1].split())
# Lowercase (support both upper and lower case hex notation)
s = s.lower()
# Strip leading "0x" if any
if (s[0] == "0" and s[1] == "x"):
    s = s[2:]
# Check string content
for c in s:
    if c not in "0123456789abcdef":
        print("Bad string \"{}\"".format(s))
        sys.exit(1)
# Convert
print("{:#b}".format(int(s, 16)))
