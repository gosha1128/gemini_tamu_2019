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
sleep 0.5
CMD="pgrep -P $PID"
C1=$(eval $CMD)
CMD="pgrep -P $C1"
C2=$(eval $CMD)
CMD="ps --no-headers -p $C2 -o pid,tty | awk '{ print \$2 }'"
TTY=$(eval $CMD)
DEV="/dev/$TTY"
BOARD=$C2
echo "BOARD INFO: $PID,$C1,$C2,$TTY,$DEV,$BOARD"

gnome-terminal --disable-factory --load-config=./termpcdmesg.cfg -- bash -c "./termpcdmesg.sh $1; bash" &
PID=$!
sleep 0.5
CMD="pgrep -P $PID"
C1=$(eval $CMD)
CMD="pgrep -P $C1"
C2=$(eval $CMD)
CMD="ps --no-headers -p $C2 -o pid,tty | awk '{ print \$2 }'"
TTY=$(eval $CMD)
DEV="/dev/$TTY"
PC=$C2
echo "PC INFO: $PID,$C1,$C2,$TTY,$DEV,$PC"

gnome-terminal --disable-factory --load-config=./termminicom.cfg -- bash -c "./termminicom.sh $1; bash" &
PID=$!
sleep 0.5
CMD="pgrep -P $PID"
C1=$(eval $CMD)
CMD="pgrep -P $C1"
C2=$(eval $CMD)
CMD="ps --no-headers -p $C2 -o pid,tty | awk '{ print \$2 }'"
TTY=$(eval $CMD)
DEV="/dev/$TTY"
MINICOM=$C2
echo "MINICOM INFO: $PID,$C1,$C2,$TTY,$DEV,$MINICOM"

gnome-terminal --disable-factory --load-config=./termsearch.cfg -- bash -c "./termsearch.sh $1; bash" 

# Now cleanup everything

echo "Killing board terminal..."
kill $BOARD
echo "Killing pc terminal..."
kill $PC
echo "Killing minicom terminal..."
kill $MINICOM

echo "Logging into board and making sure logger is shutdown..."
sudo sshpass -p "root" sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@192.168.32.4 "killall boarddmesg.sh"

echo "Syncing board log files..."
sudo sshpass -p "root" scp -r root@192.168.32.4:/home/root/logs/* ./logs/
sudo sshpass -p "root" scp -r root@192.168.32.4:/var/log/dmesg "./logs/$1/"

echo "Done."

