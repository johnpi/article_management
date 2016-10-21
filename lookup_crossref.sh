#!/bin/bash

. library_std.sh

args_num_test "$#" 1 1 "A doi string was expected as argument."

doi="${1}"
doi=$(trim "${doi}")

curl "http://api.crossref.org/works/${doi}"

