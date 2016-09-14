#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert a byte string of arbitrary length (e.g. "34a3f217be") into its binary
# representation using the "LSB 0" numbering scheme.
# TODO: add argparse, support "MSB 0"
import sys
import math

s = "".join(sys.argv[1].split())
for c in s:
    if c not in "0123456789abcdef":
        print("Bad string \"{}\"".format(s))
        sys.exit(1)
print("{:#b}".format(int(s, 16)))
