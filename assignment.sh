#!/bin/bash


# DEFAULT VALUES FOR SCRIPT ARGUMENTS
OVERWRITE=0
DESTINPUT="$(pwd)/archive"


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
        for i in $@; do  # HANDLING WRONG ORDER OF SCRIPT ARGS
            if [[ $i = "-o" ]]
            then
                echo "Wrong order of arguments. Terminating the script."
                exit 1
            fi
        done
        if [[ -d $1 ]]; then
            DESTINPUT=$1
        else
            echo "Invalid location. Terminating the script."
            exit 1
        fi
        shift
    fi

    if [[ $1 = "-p" ]] # PASSWORD ARRAYS
    then
        shift
        if [ $# -eq 0 ]; then
        echo "No passwords were passed in. Exiting the script."
        exit 1
        fi
        for i in $@; do
            if [[ $i = "-d" || $i = "-o" ]]
            then
                echo "Wrong order of arguments. Terminating the script."
                exit 1
            fi
        done

        PASSWORDS=$@
    fi
done


# UNZIPPING .ZIP FILES
while true
do
    ZIPFILES=$(find . -iname \*.zip)
    if [ -z $ZIPFILES ]; then
        break
    fi

    for i in $ZIPFILES
    do
    TRIES=0
	if 7z l -slt $i | grep -q ZipCrypto; then
	    for pass in $PASSWORDS
	    do
		unzip -P $pass "${i:2}" && rm $i && break
		zipworked=$?
	    done
	else
	    unzip "${i:2}"
	    zipworked=$?
	    rm $i
	fi
	if [ $zipworked -gt 0 ]; then
	((TRIES=TRIES+1))

	fi
    done
    if [ $TRIES -ge ${#PASSWORDS[@]} ]
        then
            echo "INCORRECT PASSWORD(S), EXITING THE SCRIPT"
            exit 1
        fi
done


# LISTING COUNT OF FILE EXTENSIONS
echo "FILE EXTENSIONS"
echo $(find . -type f | grep -i -E -o "\.\w*$" | sort | uniq -c)


# CREATING ERROR LOG FILE
logfile="./Log.txt"
>$logfile
{

# MAKING ARCHIVE DIR IF DESINATION IS DEFAULT
if [[ $DESTINPUT = "$(pwd)/archive"  ]]
then
	mkdir -p  archive
fi


# MAKING DIRECTORY BASED ON UNIQUE MOD DATE AND MOVING FILES
find . -type f | while read file
do
    if [[ $file = "./script.sh" || $file = "./Log.txt" ]]
    then
            continue
    fi

    DATE=$(date -r "$file" "+%y-%m-%d") # GET DATE FORMAT
    DEST="$DESTINPUT/$DATE" # MAKE DESTINATION
    mkdir -p "$DEST" # MAKE DIR
    if [ $OVERWRITE -eq 1 ]; then
        mv -f "$file" "$DEST" # MOVING AND OVERWRITING FILES
    elif [ $OVERWRITE -eq 0 ]; then
        mv -b "$file" "$DEST" # MOVING FILES WITHOUT OVERWRITING
    fi
done


# LOGGING ERRORS IN LOGFILE
} 2>> $logfile
linecount=$(wc -l $logfile)


# KEEPING LENGTH OF LOG FILE 10 LINES MAX
if [[ $linecount > 10 ]]; then
    $(tail -n 10 | > $logfile)
fi
