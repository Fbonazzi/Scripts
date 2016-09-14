#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert a bit string of arbitrary length (e.g. "100101011") using the "LSB 0"
# numbering scheme into its unsigned integer value and print its decimal and
# hexadecimal representations.
# TODO: add argparse, support "MSB 0"
import sys
import math

s = "".join(sys.argv[1].split())
for c in s:
    if c not in "01":
        print("Bad string \"{}\"".format(s))
        sys.exit(1)
a = 0
for i in range(0, len(s)):
    a += int(s[len(s) - i - 1]) * int(math.pow(2, i))
print("{0} ({0:#x})".format(a, a))
