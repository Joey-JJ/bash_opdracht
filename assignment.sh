#! ~/bin/zsh

# -o -d destination -p passwords
for arg in $@
do
    if [[ $1 = "-o" ]] # OVERWRITE FLAG
    then
        echo "Overwrite double files"
        shift
    fi

    if [[ $1 = "-d" ]] # NON-DEFAULT LOCATION
    then
        shift
        echo "Not the default location, destination  = $1"
        destination=$1
        shift
    fi

    if [[ $1 = "-p" ]] # PASSWORD ARRAYS
    then
        shift
        for i in $@
        do
            echo "pass: $i"
        done
    fi
done