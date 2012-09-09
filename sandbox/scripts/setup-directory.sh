#!/bin/bash

DIR=$1

if [[ ! $(whoami) == 'root' ]]
then
    echo "Must be run as root"
    exit
fi

if [[ $DIR == "" ]]
then
    echo "Usage: $0 directory"
    exit
fi

mkdir $DIR
cd $DIR

for dd in usr bin lib var etc
do
    mkdir $dd
    mount -o bind /$dd $dd
done

if [[ -d "/lib64" ]]
then
    mkdir lib64
    mount -o bind /lib64 lib64
fi

mkdir home
mkdir home/student
chmod 777 home/student

mkdir tmp
chmod 777 tmp

if [[ -e "../sub.tar.gz" ]]
then
    cp ../sub.tar.gz home/student
    (cd home/student && tar xzvf sub.tar.gz)
fi
