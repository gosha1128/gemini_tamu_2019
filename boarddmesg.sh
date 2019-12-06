#!/bin/bash

if [[ $UID -ne 0 ]]
then
        echo "Please run this script with sudo"
        exit 1
fi

if [[ $# -lt 1 ]]
  then
    echo "usage : ./boarddmseg.sh <STRING>"
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
BOARD_DATE=`date`
BOARD_DATE=`echo "$BOARD_DATE"|sed -e 's/ /_/g'`
echo "BOARD date=$BOARD_DATE"

UPTIME=`uptime`
echo "UPTIME=$UPTIME"

# Form the log file name
LOGFILE="$LPATH/BOARDDMESG--$BOARD_DATE"
echo "Will log to file $LOGFILE"

# Put the board date as first line of log file
echo "board date=$BOARD_DATE" > "$LOGFILE"

# Put uptime as next line
echo "UPTIME=$UPTIME" > "$LOGFILE"

# Put the <STRING> as next line of log file
echo "PARAMETERS: $@" >> "$LOGFILE"

# Poll dmesg and write to standard out as well as log file
echo "Monitoring and capturing dmesg logging..."
echo
while true;
do dmesg -c | tee -a "$LOGFILE"
done

