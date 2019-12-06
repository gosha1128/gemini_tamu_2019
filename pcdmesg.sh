#!/bin/bash

if [[ $UID -ne 0 ]]
then
        echo "Please run this script with sudo"
        exit 1
fi

if [[ $# -lt 1 ]]
  then
    echo "usage : ./pcdmseg.sh <STRING>"
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
echo "BOARD date=$BOARD_DATE"

# Form the log file name
LOGFILE="$LPATH/PCDMESG--$PC_DATE--$BOARD_DATE"
echo "Will log to file '$LOGFILE'"

# Put PC date as first line of log file
echo "pc date=$PC_DATE" > "$LOGFILE"

# Put the board date as next line of log file
echo "board date=$BOARD_DATE" >> "$LOGFILE"

# Put the <STRING> as next line of log file
echo "PARAMETERS: $@" >> "$LOGFILE"

# Poll dmesg and write to standard out as well as log file
echo "Monitoring and capturing dmesg logging..."
echo
while true;
do dmesg -T -c | tee -a "$LOGFILE"
done

