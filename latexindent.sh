#!/bin/bash
# Written by Filippo Bonazzi
# Indent a LaTeX file passed from standard input, and output it to standard
# output.
# To be used as a formatter in Vim.

# Generate a temporary file
tmpfile=$(mktemp --suffix=.tex)
# Redirect the data from stdin to the temporary file
cat > "$tmpfile"
# Split lines on space + at least 2-char word + full stop + space +
# uppercase letter: this correctly breaks most lines, avoiding cases such as
# dotted acronyms and middle names. e.g. the following strings will not break:
# "U.S. Navy", "Donald P. Bellisario"
sed -i -Ee 's/(\ [[:alpha:]]{2,}\.)\ ([A-Z])/\1\n\2/g' "$tmpfile"
# Remove trailing whitespace
sed -i -Ee 's/[[:space:]]+$//' "$tmpfile"
# Pass through latexindent
latexindent "$tmpfile"
retval=$?
rm "$tmpfile"
exit $retval
