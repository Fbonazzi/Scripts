#!/bin/bash
# Translate using google.translate
# By Dennis Anfossi <danfossi@itfor.it> 2013

help='translate <text> [[<source language>] <target language>]
if target missing, use Italian as default
if source missing, use auto'

# Set default lang
DEFAULT_TARGET_LANG=it

# Show help
if [[ $1 = -h || $1 = --help ]]
then
    echo "$help"
    exit
fi

if [[ $3 ]]; then
    source="$2"
    target="$3"
elif [[ $2 ]]; then
    source=auto
    target="$2"
else
    source=auto
    target="$DEFAULT_TARGET_LANG"
fi

result=$(curl -s -i --user-agent "" -d "sl=$source" -d "tl=$target" --data-urlencode "text=$1" https://translate.google.com)
encoding=$(awk '/Content-Type: .* charset=/ {sub(/^.*charset=["'\'']?/,""); sub(/[ "'\''].*$/,""); print}' <<<"$result")
iconv -f $encoding <<<"$result" |  awk 'BEGIN {RS="</div>"};/<span[^>]* id=["'\'']?result_box["'\'']?/' | html2text
exit
