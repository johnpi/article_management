#!/bin/bash

# Library of useful functions.

# SYNTAX:
#    num_in_range <NUMBER> <MIN_ACCEPTABLE> <MAX_ACCEPTABLE>
# EXAMPLE:
#    args_num_test 5 1 10
# RETURN:
#    If <MIN_ACCEPTABLE> <= <NUMBER> <= <MAX_ACCEPTABLE> return 0.
#    If <NUMBER> < <MIN_ACCEPTABLE> return 1.
#    If <NUMBER> > <MAX_ACCEPTABLE> return 2.
#    If invoked with wrong number or type of arguments return 101.
num_in_range() {
  # Check if function was invoked properly
  if [ "$#" -ne "3" ]; then
    echo -n "ERROR: Missing arguments in function call: " >&2
    return 101
  fi

  [ "$1" -lt "$2" ] && { \
    echo -n "ERROR: Missing arguments. " >&2 ; \
    return 1; \
  }
  
  [ "$1" -gt "$3" ] && { \
    echo -n "ERROR: Unexpected number of arguments. " >&2 ; \
    return 2; \
  }
  
  return 0
}



# SYNTAX:
#    args_num_test <NUM_OF_ARGUMENTS> <MIN_ACCEPTABLE> <MAX_ACCEPTABLE> <MSG>
# EXAMPLE:
#    args_num_test "$#" 1 2 "Expected arguments message to be displayed."
# BEHAVIOUR:
#    If the first argument is not within the range 
#    <MIN_ACCEPTABLE>..<MAX_ACCEPTABLE> print error 
#    message and exit with ERROR CODE 1.
#    Otherwise do nothing.
# RETURN:
#    Unimportant. 0 on success. Exit the script otherwise.
args_num_test() {
  #args_num="$#"
  #last_arg="${!args_num}"
  #message="${last_arg}"
  message="${4}_"
  message=${message%_}

  # Invoke function with only the first 3 arguments given to us
  num_in_range "${@:1:3}"
  
  case "$?" in
    101) echo "args_num_test()." >&2
	 exit 1
	 ;;
      1) echo "${message}" >&2
	 exit 1
	 ;;
      2) echo "${message}" >&2
	 exit 1
	 ;;
      0) ;;
  esac
}

# SYNTAX:
#    file_readable <FILENAME>
file_readable() {
  args_num_test "$#" 1 1
  
  [ -r "${1}" ] || { \
    echo "ERROR: The given file does not exist or is not readable." >&2 ; \
    exit 1; \
  }
}

# SYNTAX:
#    is_readable_dir <DIRECTORY_PATHNAME>
is_readable_dir() {
  args_num_test "$#" 1 1
  
  if [ -d "${1}" ] && [ -r "${1}" ]; then
    return 0
  else
    echo "ERROR: The given directory does not exist or is not readable." >&2
    return 1
  fi
}

# Remove white space from beginning and end of string
# SYNTAX
#    trim "    abc     "
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

