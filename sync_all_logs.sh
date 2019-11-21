#!/bin/bash

mkdir -p logs

scp -r root@192.168.32.4:/home/root/logs/* ./logs/

scp -r administrator@192.168.32.201:/home/administrator/knn_usa/gemini_tamu_2019/logs/* ./logs/
