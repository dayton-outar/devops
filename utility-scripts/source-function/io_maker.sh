#!/bin/bash

## Credit: Bash Cookbook: Chapter 1

source functions.sh # You may need to include the path as it is relative
FNAME="my_test_file.txt"
create_file "${FNAME}"
delete_file "${FNAME}"

exit 0