#!/bin/bash

# It extracts a doi string from a PDF article if it exists.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

# Pages to examine for doi strings
first_page=1
last_page=1
pages_num=$(pdfinfo "${File}" | grep Pages | awk '{print $2}')
if [ "${pages_num}" -gt "${first_page}" ]; then
  last_page=2
fi

# If it is a Science article then look for the doi only on the last page of 
# the file which is an extra page with the article details.
if pdftotext -enc Latin1 "${File}" - | grep '^\(SCIENCE sciencemag\.org$\|Downloaded from https\?:\/\/science\.sciencemag\.org\/ on \)' > /dev/null; then
  first_page="${pages_num}"
  last_page="${pages_num}"
fi

# If it is a Learning & Memory article then look for the doi only on the last page of the file
if pdftotext -enc Latin1 "${File}" - | grep '^Downloaded from learnmem.cshlp.org on ' > /dev/null; then
  first_page="${pages_num}"
  last_page="${pages_num}"
fi


#doi: 
# Explanation:
# 	pdftotext -enc Latin1 "${File}" - 
# 	Will extract and print to the stdout (-) the text of the document considering the character encoding as being Latin1.
# 	grep -i '\<doi:\? *[^[:space:]]\+\>'
# 	Prints only a matching string starting with an empty string at the beginning of a word then "doi", 
# 	optionally ":" and spaces and then a string of non space characters until the empty string at the end of the word.
doi=$(pdftotext -f "${first_page}" -l "${last_page}" -enc Latin1 "${File}" - | \
      grep -izo '\<\(doi:\?[[:space:]]*\|https\?:\/\/\(dx\.\)\{0,1\}doi\.org\/\)10\.[0-9]\{4,\}[^[:space:]]*\/[^[:space:]]\+\>' | \
      sed -e 's/https\?:\/\/dx\.doi\.org\///gi'              \
          -e 's/^.*doi:\? *//gi'                             \
          -e 's/[\.) ]\+$//g'                                \
          -e 's/]$//g'                                       \
          -e '/^[[:space:]]*$/d'                           | \
      head -n 1)

echo "${doi}"

