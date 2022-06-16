#! ~/bin/zsh

# DEFAULT VALUES FOR SCRIPT ARGUMENTS
OVERWRITE=0
DESTINATION="./default"
PASSWORDS=()

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

echo "O: $OVERWRITE"
echo "D: $DESTINATION"
echo "P: $PASSWORDS"
