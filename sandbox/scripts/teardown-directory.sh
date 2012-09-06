#!/bin/bash

DIR=$1

if [[ ! $USER == 'root' ]]
then
    echo "Must be run as root"
    exit
fi

if [[ ! -d "$DIR" ]]
then
    echo "Usage: $0 directory"
    exit
fi

cd $DIR

for dd in usr bin lib var
do
    umount $dd
    rmdir $dd
done

if [[ -d "lib64" ]]
then
    umount lib64
    rmdir lib64
fi

rm -rf home/student
rmdir home

cd ..
rm -rf $DIR/tmp
rmdir $DIR
