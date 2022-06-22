#!/bin/bash

# DEFAULT VALUES FOR SCRIPT ARGUMENTS
TARGET_PATH=$(pwd)
OVERWRITE=0
DESTINPUT="$(pwd)/archive"
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
        DESTINPUT=$1
        shift
    fi

    if [[ $1 = "-p" ]] # PASSWORD ARRAYS
    then
        shift
        PASSWORDS=$@
    fi
done

# UNZIPPING .ZIP FILES
Zips=$(find -name "*.zip")
for zipfile in $Zips
do
    CRYPTED=$( 7z l -slt -- $zipfile | grep -i -c "Encrypted = +" )
    if [ "$CRYPTED" -eq "1" ]; then
        for i in "${PASSWORDS[@]}"; do
            unzip $zipfile -P $i
        done
    else
    unzip $zipfile
    fi
done

# LISTING COUNT OF FILE EXTENSIONS
echo $(find . -type f | grep -i -E -o "\.\w*$" | sort | uniq -c)

# MAKING ARCHIVE DIR IF DESINATION IS DEFAULT
if [[ $DESTINPUT = "$(pwd)/archive"  ]]
then
    mkdir -p  archive
fi

# MAKING DIRECTORY BASED ON UNIQUE MOD DATE AND MOVING FILES
find . -type f | while read file
do
    if [[ $file = "./script.sh" ]]
    then
            continue
    fi
   
    DATE=$(date -r "$file" "+%y-%m-%d") # GET DATE FORMAT
    DEST="$DESTINPUT/$DATE" # MAKE DESTINATION
    mkdir -p "$DEST" # MAKE DIR
    # mv "$file" "$DEST" # MOVING FILES
done


