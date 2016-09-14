#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert an integer from its decimal representation into its hexadecimal
# representation.
# TODO: add argparse
import sys
import math

s = "".join(sys.argv[1].split())
for c in s:
    if c not in "1234567890":
        print("Bad string \"{}\"".format(s))
        sys.exit(1)
a = 0
for i in range(0, len(s)):
    a += int(s[len(s) - i - 1]) * int(math.pow(10, i))
print("{0:#x}".format(a))
