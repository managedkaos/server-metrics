#!/bin/bash -e
date

for i in $(cat servers.txt);
do
    echo
    echo
    echo
    echo "=== $i ==="
    ssh ${i} 'ubuntu-support-status --show-all' | tee ${i}-$(date +%F).support-status.txt
    echo
    echo
    echo
done
