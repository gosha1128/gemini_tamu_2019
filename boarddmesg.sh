#!/bin/bash

if [[ $# -lt 1 ]]
  then
    echo "usage : ./boarddmseg.sh <STRING>"
    exit 1
fi

mkdir -p "logs"

# Create a name for the PC log file based on the date
BOARD_DATE=`date`
BOARD_DATE=`echo "$BOARD_DATE"|sed -e 's/ /_/g'`
echo "PC date=$BOARD_DATE"

# Form the log file name
LOGFILE="BOARDDMESG--$BOARD_DATE"
echo "Will log to file 'logs/$LOGFILE'"

# Put the board date as first line of log file
echo "board date=$BOARD_DATE" > "logs/$LOGFILE"

# Put the <STRING> as next line of log file
echo "PARAMETERS: $@" >> "logs/$LOGFILE"

# Poll dmesg and write to standard out as well as log file
echo "Monitoring and capturing dmesg logging..."
while true;
do dmesg -c | tee -a "logs/$LOGFILE"
done

