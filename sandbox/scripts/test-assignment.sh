#!/bin/bash

COUNT=`find . -name Makefile | wc -l`

if [[ $COUNT -ne 1 ]]
then
    echo "Too many Makefiles in the directory tree."
    exit 
fi

find . -name "Makefile" -exec bash -c '(cd `dirname {}` && make test)' \;
