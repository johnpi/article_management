#!/bin/bash

# It extracts a doi string from a PDF article if it exists.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"

first_page=1

# If it is a Science article then look for the doi only on the last page of 
# the file which is an extra page with the article details.
if pdftotext -enc Latin1 "${File}" - | grep '^SCIENCE sciencemag.org$' > /dev/null; then
  pages_num=$(pdfinfo "${File}" | grep Pages | awk '{print $2}')
  first_page="${pages_num}"
fi

#doi: 
# Explanation:
# 	pdftotext -enc Latin1 "${File}" - 
# 	Will extract and print to the stdout (-) the text of the document considering the character encoding as being Latin1.
# 	grep -i '\<doi:\? *[^[:space:]]\+\>'
# 	Prints only a matching string starting with an empty string at the beginning of a word then "doi", 
# 	optionally ":" and spaces and then a string of non space characters until the empty string at the end of the word.
doi=$(pdftotext -f "${first_page}" -enc Latin1 "${File}" - | \
      grep -izo '\<doi:\?[[:space:]]*[^[:space:]]\+\>'     | \
      sed -e 's/^.*doi:\? *//gi'                             \
          -e 's/[\.) ]\+$//g'                                \
          -e 's/]$//g'                                       \
          -e '/^[[:space:]]*$/d'                           | \
      head -n 1)

# If the above search for a strings starting with the word doi failed try searching just for something that look like the doi code itself
if [ -z "${doi}" ]; then
  doi=$(pdftotext -enc Latin1 "${File}" -                 | \
        # If a Science article due to some articles not starting on top of 
        # page, get rid of everything before the start of the article so we 
        # don't capture doi strings from preceding article.
        awk '/^SCIENCE sciencemag.org/{p=1}p'             | \
        grep -izo '\<10\.[1-9][0-9]\{3\}[^[:space:]]\+\>' | \
        sed -e 's/[\.) ]\+$//g'                             \
            -e 's/]$//g'                                    \
            -e '/^[[:space:]]*$/d'                        | \
        head -n 1)
fi

echo "${doi}"

