#!/bin/bash
# !!! PAY ATTENTION TO THE 42nd and 62nd line, replace with your actual network device!!!!
apt-get update
apt-get install -y net-tools apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
service docker start
usermod -aG docker ${USER}
# Configure docker for openshift
service docker stop
docker_config_file="/etc/docker/daemon.json"
touch ${docker_config_file}
echo "{" > ${docker_config_file}
echo '"insecure-registries": ["172.30.0.0/16"],' >> ${docker_config_file}
echo '"default-address-pools": [{"base": "10.222.0.0/16", "size": 24}],' >> ${docker_config_file}
echo '"dns": ["8.8.8.8", "1.1.1.1"]' >> ${docker_config_file}
echo "}" >> ${docker_config_file}
# Restart docker service
service docker start
# Download and install Openshift client tools
pushd /tmp
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar xvfz openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
mv oc /usr/local/bin
mv kubectl /usr/local/bin
popd
# install resolvconf package to fix dns issues
apt-get -y install resolvconf
echo "nameserver 8.8.8.8" > /etc/resolvconf/resolv.conf.d/head
echo "nameserver 1.1.1.1" >> /etc/resolvconf/resolv.conf.d/head
service resolvconf restart

echo "--------Finish configuration docker-------------------"

curl -L https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 -o /usr/local/bin/helm
chmod +x /usr/local/bin/helm

echo "--------Finish configuration helm-------------------"
