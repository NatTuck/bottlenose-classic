#!/bin/bash

COUNT=`find . -name Makefile | wc -l`

if [[ $COUNT -ne 1 ]]
then
    echo "Need exactly 1 Makefile in directory tree."
    echo "Found $COUNT instead, giving up."
    exit 
fi

find . -name "Makefile" -exec bash -c '(cd `dirname {}` && make test)' \;
