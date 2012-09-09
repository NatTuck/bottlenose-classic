#!/bin/bash

COUNT=`find . -name "grade.sh" | wc -l`

if [[ ! $COUNT -eq 1 ]]
then
    echo "Expected exactly one grade.sh script."
    echo "Giving up."
    exit
fi

KEY=$1

find . -name "grade.sh" -exec {} $KEY \;
