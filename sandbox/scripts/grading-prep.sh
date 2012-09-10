#!/bin/bash

cd $1

if [[ -e "../grading.tar.gz" ]]
then
    cp ../grading.tar.gz home/student
    (cd home/student && tar xzvf grading.tar.gz)
fi
