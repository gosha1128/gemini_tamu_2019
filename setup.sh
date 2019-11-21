#!/bin/bash

gnome-terminal --load-config=./termboard.cfg &
echo $!
gnome-terminal --load-config=./termpcdmesg.cfg
echo $$
gnome-terminal --load-config=./termminicom.cfg
echo $$
gnome-terminal --load-config=./termsearch.cfg
echo $$
