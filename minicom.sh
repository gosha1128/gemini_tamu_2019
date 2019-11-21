#!/bin/bash

if [[ $# -lt 1 ]]
  then
    echo "usage : ./minicom.sh <STRING>"
    exit 1
fi

mkdir -p "logs"

# Create a name for the PC log file based on the date
PC_DATE=`date`
PC_DATE=`echo "$PC_DATE"|sed -e 's/ /_/g'`
echo "PC date=$PC_DATE"

# Get the date on SE120
echo "Getting the board date..."
BOARD_DATE=$(sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@192.168.32.4 'date' )
BOARD_DATE=`echo "$BOARD_DATE"|sed -e 's/ /_/g'`
echo "BOARD date=$BOARD_DATE"

# Form the log file name
LOGFILE="PCDMINICOM--$PC_DATE--$BOARD_DATE"
echo "Will log to file 'logs/$LOGFILE'"

# Launch minicom
echo "Launch minicom..."
minicom --device /dev/ttyUSB1 -C "logs/$LOGFILE"

# Put the <STRING> as next line of log file
echo "" >> "logs/$LOGFILE"
echo "PARAMETERS: $@" >> "logs/$LOGFILE"
