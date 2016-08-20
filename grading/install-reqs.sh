#!/bin/bash

echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
apt-get update -y
apt-get install -y openjdk-8-jdk gradle
apt-get install -y ruby2.3
apt-get install -y build-essential
apt-get install -y --allow-unauthenticated sbt

adduser --disabled-password --gecos "" student
