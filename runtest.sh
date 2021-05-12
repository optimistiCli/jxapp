#!/bin/bash

set -e

swift build

echo ''

R="$(.build/debug/jxapp Tests/test.js)"

if [ "$R" == '1234' ] ; then
    echo 'Test was successful'
    exit 0
else
    echo "Test failed >>>$R<<<"
    exit 1
fi