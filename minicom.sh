#!/bin/bash

if [[ $UID -ne 0 ]]
then
        echo "Please run this script with sudo"
        exit 1
fi

if [[ $# -lt 1 ]]
  then
    echo "usage : ./minicom.sh <STRING>"
    exit 1
fi

LPATH="logs/$LOGFILE"
if [[ ! -z $LF ]]
then
        LPATH="logs/$LF"
fi
echo "log path = $LPATH"
mkdir -p $LPATH

# Create a name for the PC log file based on the date
PC_DATE=`date`
PC_DATE=`echo "$PC_DATE"|sed -e 's/ /_/g'`
echo "PC date=$PC_DATE"

# Get the date on SE120
echo "Getting the board date..."
BOARD_DATE=$(sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@192.168.32.4 'date' )
BOARD_DATE=`echo "$BOARD_DATE"|sed -e 's/ /_/g'`
echo "Got BOARD date=$BOARD_DATE"
echo

# Form the log file name
LOGFILE="$LPATH/PCDMINICOM--$PC_DATE--$BOARD_DATE"
echo "Will log to file '$LOGFILE'"
echo

# Launch minicom
echo "Launch minicom..."
minicom --device /dev/ttyUSB1 -C "$LOGFILE"

# Put the <STRING> as next line of log file
echo "" >> "$LOGFILE"
echo "PARAMETERS: $@" >> "$LOGFILE"
