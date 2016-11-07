#!/usr/bin/env python

import argparse
import os
import os.path
import sys
import re

parser = argparse.ArgumentParser(
    description="Move the year information to the front or to the back of "
    "the string respectively.")
parser.add_argument("-b", "--back", action="store_false", default=True,
                    help="Move the year to the back of the string", dest="front")
parser.add_argument("files", nargs="+", help="The files to process")

args = parser.parse_args()

r_back = re.compile("(.+)\(([0-9]{4})\)")
r_front = re.compile("\(([0-9]{4})\)(.+)")

for f in args.files:
    if os.path.isdir(f):
        if args.front:
            # Take the year from the back of the string and move it to the
            # front
            m = r_back.match(f)
            if m:
                name = m.group(1).rstrip("/").strip()
                year = m.group(2)
                newname = "({}) {}".format(year, name)
                try:
                    os.rename(f, newname)
                except OSError:
                    print "Directory \"{}\" exists".format(newname)
            else:
                print "Unsupported file {}".format(f)
        else:
            m = r_front.match(f)
            if m:
                year = m.group(1)
                name = m.group(2).rstrip("/").strip()
                newname = "{} ({})".format(name, year)
                try:
                    os.rename(f, newname)
                except OSError:
                    print "Directory \"{}\" exists".format(newname)
            else:
                print "Unsupported file {}".format(f)
    elif os.path.isfile(f) and f.endswith(("mp4", "avi", "mkv")):
        filename, ext = os.path.splitext(f)
        if args.front:
            # Take the year from the back of the string and move it to the front
            m = r_back.match(filename)
            if m:
                name = m.group(1).strip()
                year = m.group(2)
                newname = "({}) {}{}".format(year, name, ext)
                os.rename(f, newname)
            else:
                print "Unsupported file {}".format(f)
        else:
            m = r_front.match(filename)
            if m:
                year = m.group(1)
                name = m.group(2).strip()
                newname = "{} ({}){}".format(name, year, ext)
                os.rename(f, newname)
            else:
                print "Unsupported file {}".format(f)
    else:
        print "Unsupported file {}".format(f)
