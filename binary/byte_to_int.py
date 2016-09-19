#!/usr/bin/env python
# Written by Filippo Bonazzi <f.bonazzi@davide.it> 2016
#
# Convert an integer from its hexadecimal representation to its decimal
# representation.
import sys

# Handle one of either command line input or stdin
if len(sys.argv) > 1:
    content = sys.argv[1:]
else:
    content = sys.stdin.readlines()

for each in content:
    # Remove whitespace
    s = "".join(each.split())
    # Lowercase (support both upper and lower case hex notation)
    s = s.lower()
    # Strip leading "0x" if any
    if (s.startswith("0x")):
        s = s[2:]
    # Check string content
    for c in s:
        if c not in "0123456789abcdef":
            print("Bad string \"{}\"".format(s))
            sys.exit(1)
    # Convert
    print("{:#d}".format(int(s, 16)))
