#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert an integer from its hexadecimal representation to its decimal
# representation.
# TODO: add argparse
import sys

s = "".join(sys.argv[1].split())
if (s[0] == "0" and s[1] == "x"):
    s = s[2:]
for c in s:
    if c not in "0123456789abcdef":
        print("Bad string \"{}\"".format(s))
        sys.exit(1)
print("{:#d}".format(int(s, 16)))
