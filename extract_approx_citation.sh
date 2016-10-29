#!/bin/bash

# If everything else fails try to extract citation information from the paper

. library_std.sh

args_num_test "$#" 1 1 "A path to a PDF file should be given as argument."

file_readable "${1}"

File="${1}"


# Possible patterns:
# 1. Example string    : Neuron, Vol. 26, 259–271, April, 2000,
#    Regular expression: \<\([[:alpha:]]\+\)\>,[[:space:]]\+Vol\.[[:space:]]\+\([[:digit:]]\+\),[[:space:]]\+\([[:digit:]]\+<AD>[[:digit:]]\+\),[[:space:]]\+\<\((January|February|March|April|May|June|July|August|September|October|November|December)\)\>,[[:space:]]\+\([[:digit:]]\+\)
