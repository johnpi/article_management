#!/bin/bash

# It extracts a ISBN string from a PDF article if it exists.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

# Pages to examine for doi strings
first_page=1
last_page=10
pages_num=$(pdfinfo "${File}" | grep Pages | awk '{print $2}')
if [ "${pages_num}" -lt "${last_page}" ]; then
  last_page="${pages_num}"
fi

#isbn: 
# Explanation:
# 	pdftotext "${File}" - 
# 	Will extract and print to the stdout (-) the text of the document considering the character encoding as being UTF8.
isbn=$(pdftotext -f "${first_page}" -l "${last_page}" "${File}" -     | \
       grep -izo '\<ISBN:\?[[:space:]]*[-[:digit:]]\{10,\}' | \
       sed -e 's/^.*ISBN:\?[[:space:]]*//gi'                  \
           -e 's/[-]//g'                                      \
           -e '/^[[:space:]]*$/d'                           | \
       head -n 1)

if [ "${#isbn}" -eq "10" ] || [ "${#isbn}" -eq "13" ]; then
  echo "${isbn}"
else
  echo "WARNING: An ISBN number couldn't be found in the file. Skipping ${File}" >&2
  echo ""
fi

