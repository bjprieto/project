#!/bin/bash
# getbooks.sh

# Input Quality Control

# address on Gutenberg.org --> check can wget

# quality control: one argument
if ! [[ $# -eq 1 ]]
then
    1>&2 printf 'invalid number of arguments; expected 1, got %d\n' $#
    exit
fi

# quality control: UTF-8 format
if ! $(grep -Eoq 'https://www.gutenberg.org/ebooks/[[:digit:]]+\.txt\.utf-8' $1)
then
    1>&2 printf 'invalid file format; expected at least one web address in plain text UTF-8 format'
    exit
fi

# Effects

# perform downloads

for web in $(cat $1)
do
    
done

# scrub for author, title
# chk book exists in repo
# if not, download in a directory named after author, file name with book title
