#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert a byte string (e.g. "34a3f217be") into its C byte representation
# (e.g. "0x34, 0xa3, 0xf2, 0x21, 0xbe") ready to be copy-pasted in C source.
# TODO: add argparse
import sys

# Remove whitespace
s = "".join(sys.argv[1].split())
# Lowercase (support both upper and lower case hex notation)
s=s.lower()
# Strip leading "0x" if any
if (s[0] == "0" and s[1] == "x"):
    s = s[2:]
# Check string content
for c in s:
    if c not in "0123456789abcdef":
        print("Bad string \"{}\"".format(s))
        sys.exit(1);
# Right-align the string with zeroes to a multiple of 2
if len(s) % 2:
    s = "0" + s
# Write out byte values prepended by "0x"
l = []
for i in range(0, len(s), 2):
    l.append("0x{}{}".format(s[i], s[i + 1]))
# Write the comma-joined C representation
print(", ".join(l))
