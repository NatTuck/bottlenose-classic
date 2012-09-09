#!/bin/bash
find . -name "Makefile" -exec bash -c '(cd `dirname {}` && make)' \;
