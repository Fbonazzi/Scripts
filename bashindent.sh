#!/bin/bash
# Written by Filippo Bonazzi (2016)
# Indent a Bash script passed from standard input, and output it to standard
# output.
# Basically a wrapper for beautify_bash.py to be used as a formatter in Vim.

# Generate a temporary file
tmpfile=$(mktemp)
# Pass through beautify_bash.py
cat | beautify_bash.py - > "$tmpfile"
retval=$?
# If beautify_bash.py returned an error, quit immediately
if [ $retval -ne 0 ]
then
  rm "$tmpfile"
  exit $retval
fi
# Remove trailing whitespace
sed -i -Ee 's/[[:space:]]+$//' "$tmpfile"
# Print the output
cat "$tmpfile"

rm "$tmpfile"
exit $retval
