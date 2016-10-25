#!/bin/bash

# Usage: doi2bib.sh 10.1021/la203078w

.library_std.sh

args_num_test "$#" 1 1 "A doi string was expected as argument."

doi="${1}"
doi=$(trim "${doi}")

curl -LH "Accept: application/x-bibtex;q=1" "http://dx.doi.org/${doi}"
#curl -LH "Accept: application/x-bibtex; charset=utf-8" "http://dx.doi.org/${doi}"
echo
