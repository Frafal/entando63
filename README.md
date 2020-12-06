# Install Entando 6.3 in local development environment
Prerequisites: 
- multipass
- hyper-v enable on windows host

## Install okd3, helm and set static ip for multipass VM
```
multipass launch --name ubuntu-entando --cpus 6 --mem 8G --disk 20G
multipass shell ubuntu-entando
sudo apt update && sudo apt upgrade
git clone https://github.com/Frafal/entando63.git
cd entando63
sudo chmod +x INSTALL-okd-0.sh
sudo ./INSTALL-okd-0.sh
sudo chmod+x static-ip.sh
sudo ./static-ip.sh
sudo shutdown -h now
```
## Install Entando 6.3
```
multipass shell ubuntu-entando
cd entando63
```
# !!! PAY ATTENTION TO THE 9nd of INSTALL-okd-1.sh, replace eth0 with your actual network device!!!!
```
sed -i "s/UTENTE/${USER}/" INSTALL-okd-1.sh
sudo chmod +x INSTALL-okd-1.sh
sudo ./INSTALL-okd-1.sh
```

## Access from host macchine to okd console 

From console in ubuntu-entando run:
```
ip r
```
copy the second ip of VM from the first line
```
default via 192.168.162.17 dev eth0 proto dhcp src 192.168.162.30 metric 100
```
(i.e. 192.168.162.30)


copy the output of
```
ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
```
(i.e 192.168.238.116)


ON WINDOWS host from powershell as administrator run:
```
route ADD 192.168.238.116 192.168.162.30
```

## Start and stop local cluster
Start:
```
sudo oc cluster up --public-hostname=${myIP} --enable=* --base-dir=/home/UTENTE/openshift-conf
(i.e. sudo oc cluster up --public-hostname=192.168.238.116 --enable=* --base-dir=/home/ubuntu/openshift-conf)
```
Stop:
```
sudo oc cluster down
```

