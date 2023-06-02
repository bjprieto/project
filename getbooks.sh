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


# Primary Function

# perform downloads
for web in $(cat $1)
do
    # extract temporary file name
    file=$(echo $web | grep -Eo '[[:digit:]]+\.txt\.utf-8')
    # echo $file # check extraction

    # check if file is preexisting with default wget name
    if ! [[ -f $file ]]
    then

	# download book and extract relevant information
	wget -q $web
        title=$(head -1 $file | sed 's/.\+[Ee]Book[[:space:]]of[[:space:]]//; s/,.\+//; s/[[:punct:]]//g; s/\ /_/g' | tr [:upper:] [:lower:])
	author=$(head -1 $file | sed 's/.\+,[[:space:]]by[[:space:]]//; s/[[:space:]]$//;s/[[:punct:]]//g; s/\ /_/g' | tr [:upper:] [:lower:])

	# check block for info extraction
	# echo $title
	# echo $author

	# check author directory exists
	if ! [[ -d $author ]]
	then

	    # create corresponding directory and file
	    mkdir $author
	    mv $file "$author/$title.txt"
	else

	    # check book exists in the preexisting directory
	    if ! [[ -f "$author/$title.txt" ]]
	    then
       		mv $file "$author/$title.txt"
	    else
		printf 'exists already\n'
	    fi
	    
	fi
	
    else
	printf 'exists already\n'
    fi
done
