#!/bin/bash

# DEFAULT VALUES FOR SCRIPT ARGUMENTS
TARGET_PATH=$(pwd)
OVERWRITE=0
DESTINATION=$(pwd)
PASSWORDS="empty"

# ARGS HANDLING
for arg in $@
do
    if [[ $1 = "-o" ]] # OVERWRITE FLAG
    then
        OVERWRITE=1
        shift
    fi

    if [[ $1 = "-d" ]] # NON-DEFAULT LOCATION
    then
        shift
        DESTINATION=$1
        shift
    fi

    if [[ $1 = "-p" ]] # PASSWORD ARRAYS
    then
        shift
        PASSWORDS=$@
    fi
done

# NAVIGATING TO DESTINATION DIRECTORY
# cd "$DESTINATION"
# mkdir "archive"

# MAKING DIRECTORY BASED ON UNIQUE MOD DATE AND MOVING FILES
find . -type f | while read file
do
    if [[ $file = "./test.sh" ]]
    then
            continue
    fi
    
    DATE=$(date -r "$file" "+%y-%m-%d") # GET DATE FORMAT
    DEST="./$DATE" # MAKE DESTINATION
    mkdir -p "$DEST" # MAKE DIR
    mv "$file" "$DEST" # MOVING FILES
done
