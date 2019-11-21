#!/bin/bash

if [[ $# -lt 1 ]]
  then
    echo "usage : $0 <STRING>"
    exit 1
fi

echo "This is the hamming search program."
echo
read -n 1 -p "Verify the other terminals started.  Press any key to start:"

LF=$1 ./search.sh 10000 192.168.32.4 $1
