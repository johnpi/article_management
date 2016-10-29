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
doi="$(./extract_doi.sh ${File})"

# If no doi was found exit
if [ -z "${doi}" ]; then
  echo "WARNING: No doi was found in the file. Skipping ${File}"
  exit 1
fi

# Generate a new file name for the file complying with the form:
# LastName_Year_Publication.Extension
New_Filename=$(./lookup_crossref.sh "${doi}" | ./gen_filename.py) && \
# Rename the file to comply with the form LastName_Year_Publication.Extension
mv "${File}" "$(dirname ${File})/${New_Filename}${Ext}" && \
exit 0

echo "ERROR: The doi couldn't be remotely resolved or the file couldn't be renamed."
exit 1
