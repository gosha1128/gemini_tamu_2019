#!/bin/bash

if [[ $# -lt 3 ]]
  then
    echo "usage : ./search.sh iter_num (0 for infinite) Board_IP <STRING>"
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
LOGFILE="$LPATH/SEARCH--$PC_DATE--$BOARD_DATE"
echo "Will log to file $LOGFILE"

# Put PC date as first line of log file
echo "pc date=$PC_DATE" > "$LOGFILE"

# Put the board date as next line of log file
echo "board date=$BOARD_DATE" >> "$LOGFILE"

# Put the <STRING> as next line of log file
echo "PARAMETERS: $@" >> "$LOGFILE"

proc2=$(sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@$2 'ps -o comm,pid | grep -v grep | grep gsifw ' | awk '{print $2;}' )
#echo $proc2
if [[ $proc2 == '' ]]
then
	echo "run arc"
	nohup sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@$2 '/run/media/mmcblk0p1/system/bin/run_app' &
	echo "Waiting 10 seconds for the arc to load..."
	sleep 10
	cat nohup.out | tee -a "$LOGFILE"
else
	echo "arc already running"
fi
#export LD_LIBRARY_PATH=../00.09.00/libs; export PYTHONPATH=../00.09.00:../00.09.00/gnlpy:../00.09.00/gnlpy/lib:../00.09.00/libs; python3.6 knn_binding_usa.py $1 | tee -a "$LOGFILE"
export LD_LIBRARY_PATH=00.09.00/libs; export PYTHONPATH=00.09.00:00.09.00/gnlpy:00.09.00/gnlpy/lib:00.09.00/libs; cd ..; pwd; stdbuf -o 0 python3.6 -u knn_binding_usa.py $1 | tee -a "gemini_tamu_2019/$LOGFILE" ; cd gemini_tamu_2019
proc=$(sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@$2 'ps -o comm,pid | grep -v grep | grep gsifw ' | awk '{print $2;}' )
if [[ $proc != '' ]]
then
	echo "terminate arc" | tee -a "$LOGFILE"
	sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@$2 "kill -9 $proc"
fi
echo "search completed" | tee -a "$LOGFILE"
