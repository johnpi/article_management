#!/bin/bash

# Extracts the doi string from a PDF article and if successful it renames the file in a standard format.

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

# This is the file given as argument
File="${1}"
# This is the extension of the file if any
Ext=".${File##*.}"
[ "${#Ext}" -le "1" ] && Ext=""

# Try to extract the doi from the file
doi=$(./extract_doi.sh "${File}")

# If no doi was found try looking for an ISBN
if [ -z "${doi}" ]; then
  # Try to extract the ISBN from the file
  isbn=$(./extract_isbn.sh "${File}")
fi

# If no doi was found exit
if [ -z "${doi}" ] && [ -z "${isbn}" ]; then
  echo "WARNING: No DOI or ISBN was found in the file. Skipping ${File}" >&2
  exit 1
fi


filenameonly=$(basename "${File}")
[ -n "${doi}"  ] && echo "File: ${filenameonly} => ${doi}"  >&2
[ -n "${isbn}" ] && echo "File: ${filenameonly} => ${isbn}" >&2

[ -n "${doi}"  ] && ./doi2bib.sh "${doi}" >> collection.bib

# Generate a new file name for the file complying with the form:
# LastName_Year_Publication.Extension
[ -n "${doi}"  ] && New_Filename=$(./lookup_crossref.sh "${doi}" | ./gen_filename.py)
if [ -z "${New_Filename}" ]; then
  echo "WARNING: No better filename was derived. Skipping ${File}" >&2
  exit 1
fi
NewFilename=$(dirname "${File}")/"${New_Filename}${Ext}"

# If the filename has changed then move otherwise not to avoid error messages
if [ "${File}" != "${NewFilename}" ]; then
  # Make sure the new file name is unique. If not unique and both files are identical just keep one of them. Otherwise generate a unique filename.
  file_index=1
  while [[ -e "${File}" && -e "${NewFilename}" ]]
  do
    let "file_index+=1"
    cmp "${File}" "${NewFilename}" && rm "${File}" || NewFilename=$(dirname "${File}")/"${New_Filename}_${file_index}${Ext}"
  done
  # Rename the file to comply with the form LastName_Year_Publication.Extension
  [ -e "${File}" ] && mv "${File}" "${NewFilename}"

  [ "$?" -ne "0" ] && { \
    echo "ERROR: The file couldn't be renamed." >&2 ; \
    exit 1; \
  } || echo "INFO: Renamed: ${File} => ${NewFilename}" >&2
fi

exit 0


