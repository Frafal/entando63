#!/bin/bash
myIP=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
sed -i "s/myIP/$myIp" 90-static.yaml
mv 90-static.yaml /etc/netplan/
netplan apply
