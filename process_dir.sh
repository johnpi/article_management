#!/bin/bash

# Scans a directory hierarchy for articles and processes each of them.

. library_std.sh

if [ "$#" -gt "0" ] && [ -e "${1}" ]; then
   Directory="${1}"
else
   Directory="/"
fi

Directory=$(realpath "${Directory}")
echo "Processing ${Directory}" >&2
find "${Directory}" -iname '*.pdf' -type f -exec ./process_pdf.sh '{}' \;
