#!/bin/bash

. library_std.sh

args_num_test "$#" 1 1

file_readable "${1}"

File="${1}"


echo "Proccessing: ${File}"

#doi: 
#9 SEPTEMBER 2016 · VOL 353 ISSUE 6304


text="temp.txt"
pdftotext -enc Latin1 "${File}" "${text}" 
doi="$(cat "${text}" | grep -i '[^a-zA-Z]doi: *[^ ]\+' | head -n 1 | sed -e 's/^.*doi:\? *//gi' -e 's/[\.) ]\+$//g' -e 's/]$//g')"
date="$( cat "${text}" | grep -i '[0-9]\+ \+\(JANUARY\|FEBRUARY\|MARCH\|APRIL\|MAY\|JUNE\|JULY\|AUGUST\|SEPTEMBER\|OCTOBER\|NOVEMBER\|DECEMBER\) \+[0-9]\+' | head -n 1)"

echo "DOI is ${doi}"
echo "DATE is ${date}"

