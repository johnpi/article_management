#!/bin/bash

# It looks up a ISBN string and returns a full json record.

. library_std.sh

args_num_test "$#" 1 1 "An ISBN string was expected as argument."

isbn="${1}"
isbn=$(trim "${isbn}")

curl -sL "https://www.googleapis.com/books/v1/volumes?q=isbn:${isbn}"

