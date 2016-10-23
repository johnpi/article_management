#!/bin/bash

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

# This is the file given as argument
File="${1}"
# This is the extension of the file if any
Ext=".${File##*.}"
[ "${#Ext}" -le "1" ] && Ext=""

# Generate a new file name for the file complying with the form:
# LastName_Year_Publication.Extension
New_Filename=$(./lookup_crossref.sh "$(./extract_doi.sh ${File})" |  \
               ./gen_filename.py)                                 && \
# Rename the file to comply with the form LastName_Year_Publication.Extension
mv "${File}" "$(dirname ${File})/${New_Filename}${Ext}"

