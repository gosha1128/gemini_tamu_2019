#!/bin/bash

echo "$0,$1"
if [[ $# -lt 1 ]]
  then
    echo "usage : $0 <STRING>"
    exit 1	  
fi

echo "This is the board's system log capture program."
sleep 0.5
echo 
echo "Syncing scripts to board..."
sudo sshpass -p "root" scp ./boarddmesg.sh root@192.168.32.4:/home/root/
if [ "$?" -ne "0" ]
then
	echo "SCP error"
	exit 1
fi
echo "OK."
sleep 0.5
echo "Running log capture script..."
sleep 0.5
sudo sshpass -p "root" sudo sshpass -p "root" ssh -o StrictHostKeyChecking=no root@192.168.32.4 "./boarddmesg.sh $1"
if [ "$?" -ne "0" ]
then
	echo "SSH error"
	exit 1
fi
