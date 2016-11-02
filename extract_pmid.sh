#!/bin/bash

# It extracts a PMID string from a PDF article if it exists.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

# Pages to examine for PMID strings
first_page=1
last_page=1
pages_num=$(pdfinfo "${File}" | grep Pages | awk '{print $2}')
if [ "${pages_num}" -gt "${last_page}" ]; then
  last_page=2
fi

#isbn: 
# Explanation:
# 	pdftotext "${File}" - 
# 	Will extract and print to the stdout (-) the text of the document considering the character encoding as being UTF8.
pmid=$(pdftotext -f "${first_page}" -l "${last_page}" "${File}" - | \
       grep -izo '\<PMID:\?[[:space:]]*[[:digit:]]\{8\}\>' | \
       sed -e 's/^.*PMID:\?[[:space:]]*//gi'                  \
           -e 's/[-]//g'                                      \
           -e '/^[[:space:]]*$/d'                           | \
       head -n 1)

if [ "${#pmid}" -eq "8" ]; then
  echo "${pmid}"
else
  echo "WARNING: An PMID number couldn't be found in the file. Skipping ${File}" >&2
  echo ""
fi

