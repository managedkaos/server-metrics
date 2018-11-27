#!/bin/bash -e
date

for i in $(cat servers.txt);
do
    ssh ${i} 'wget --quiet http://s3.amazonaws.com/ec2metadata/ec2-metadata -O ec2-metadata && chmod +x ec2-metadata'
    ssh ${i} 'wget --quiet --no-check-certificate https://raw.githubusercontent.com/smxi/inxi/master/inxi -O inxi && chmod +x inxi'
    ssh ${i} './inxi -S -D -I -p -c 0'    > ${i}-$(date +%F).inxi.txt
    ssh ${i} './ec2-metadata --all'       > ${i}-$(date +%F).meta.txt
    ssh ${i} 'apt list --upgradable 2>&1' > ${i}-$(date +%F).pkgs.txt
    ssh ${i} 'df -h /'                    > ${i}-$(date +%F).disk.txt
    ssh ${i} 'rm -vf ec2-metadata inxi'

    echo "=== $i ==="
    echo -n "Uptime: "
    ssh ${i} 'uptime'
    echo
    pkgs=$(cat ${i}-$(date +%F).pkgs.txt | wc -l)
    echo "Packages: $pkgs packages need to be upgraded"
    echo
    cat ${i}-$(date +%F).inxi.txt
    echo
    cat ${i}-$(date +%F).disk.txt
    echo
    echo
    echo
done
