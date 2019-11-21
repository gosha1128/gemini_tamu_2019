#!/bin/bash

if [[ $UID != 0 ]]
then
	echo "Please run this script with sudo"
	exit 1
fi

if [[ $# -lt 1 ]]
  then
    echo "usage : $0 <STRING>"
    exit 1        
fi

if [[ -d "logs/$1" ]]
then
	echo "The log directory 'logs/$1' already exists.  Please choose a different test parameter."
	exit 1
fi

gnome-terminal --disable-factory --load-config=./termboarddmesg.cfg -- bash -c "./termboarddmesg.sh $1; bash" &
PID=$!
#sleep 0.5
CMD="pgrep -P $PID"
C1=$(eval $CMD)
CMD="pgrep -P $C1"
C2=$(eval $CMD)
CMD="ps --no-headers -p $C2 -o pid,tty | awk '{ print \$2 }'"
TTY=$(eval $CMD)
DEV="/dev/$TTY"
#echo "" > $DEV
#echo "# When you are ready, hit ENTER" > $DEV
#echo "./termboard.sh" > $DEV
#echo "$PID,$C1,$C2,$TTY,$DEV"

gnome-terminal --disable-factory --load-config=./termpcdmesg.cfg -- bash -c "./termpcdmesg.sh $1; bash" &

gnome-terminal --disable-factory --load-config=./termminicom.cfg -- bash -c "./termminicom.sh $1; bash" &

gnome-terminal --disable-factory --load-config=./termsearch.cfg -- bash -c "./termsearch.sh $1; bash" &


