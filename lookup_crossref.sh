#!/bin/bash

# It looks up a doi string and returns a full json crossref record.

. library_std.sh

args_num_test "$#" 1 1 "A doi string was expected as argument."

doi="${1}"
doi=$(trim "${doi}")

curl -sL "http://api.crossref.org/works/${doi}"

[ "$?" -ne "0" ] && echo "The doi couldn't be remotely resolved: ${doi}" >&2