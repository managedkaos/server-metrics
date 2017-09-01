#!/bin/bash -e
date

for i in $(cat servers.txt);
do
    ssh ${i} './inxi -S -D -I -p -c 0'    > ${i}-$(date +%F).inxi.txt
    ssh ${i} './ec2-metadata --all'       > ${i}-$(date +%F).meta.txt
    ssh ${i} 'apt list --upgradable 2>&1' > ${i}-$(date +%F).pkgs.txt
    ssh ${i} 'df -h'                      > ${i}-$(date +%F).disk.txt

    echo "=== $i ==="
    echo -n "Uptime: "
    ssh ${i} 'uptime'
    pkgs=$(cat ${i}-$(date +%F).pkgs.txt | wc -l)
    echo "Packages: $pkgs packages need to be upgraded"
    cat ${i}-$(date +%F).inxi.txt
    cat ${i}-$(date +%F).disk.txt
    echo
    echo
    echo
done
