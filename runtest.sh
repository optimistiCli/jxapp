#!/bin/bash

# Usage:
#   ./runtest.sh
#     Runs all bats'
#   ./runtest.sh Tests/00_precondition.bats
#     Runs particular bats
#   ./runtest.sh precondition
#     Runs all bats with names containing given string

set -e

swift build

echo ''

if [ -n "$1" ] ; then
    BUF=''
    while [ -n "$1" ] ; do
        if ls "$1" 1>/dev/null 2>/dev/null ; then
            if [[ "$1" == Tests/* ]] && [[ "$1" == *.bats  ]] ; then
                BUF="$BUF $1"
            else 
                echo "Error: bad test >>>$1<<<"
            fi
        else
            if ls Tests/*"$1"*.bats 1>/dev/null 2>/dev/null ; then
                while IFS='' read -r -d $'\n' f ; do
                    BUF="$BUF $f"
                done<<<"$(ls -1 Tests/*"$1"*.bats 2>/dev/null)"
            else 
                echo "Error: no such test >>>$1<<<"
            fi
        fi
        shift
    done
    ./Library/bats-core/bin/bats $BUF
else
    ./Library/bats-core/bin/bats Tests/
fi
