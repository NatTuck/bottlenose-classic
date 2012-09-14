#!/bin/bash
#mount
find . -name "Makefile" -exec bash -c '(cd `dirname {}` && make)' \;
