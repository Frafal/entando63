#!/bin/bash
# !!! PAY ATTENTION TO THE 9nd, replace eth0 with your actual network device!!!!

# Start Openshift cluster
#Retreive actual IP address

# --- CHECK YOUR ACTUAL INTERFACE NAME --

myIP=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

#Start Openshift cluster
oc cluster up --public-hostname=${myIP} --enable=* --base-dir=/home/UTENTE/openshift-conf

# Assign cluster role permissions to the user developer
sleep 5
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer

# Create a default projet calles my-app
sleep 5
oc new-project my-app

# Clone the entando custom resourses and install them
git clone https://github.com/entando-k8s/entando-k8s-custom-model.git --branch v6.2.7
oc create -f entando-k8s-custom-model/src/main/resources/crd/

sleep 5

# Clone the entando helm quick start and install in my-app
git clone https://github.com/entando-k8s/entando-helm-quickstart.git --branch v6.3.0
cd entando-helm-quickstart
sed -i "s/your.domain.suffix.com/$myIP.nip.io/" values.yaml
helm dependency update .
helm template --namespace=my-app ./ > my-app.yaml
sleep 2
sed -i "s/RELEASE-NAME-operator/entando-app/" my-app.yaml
sed -i "s/1000/10000/" my-app.yaml
oc create -f my-app.yaml

echo "----------------------------------------------------------------"

echo "Custom resource definition installed."
echo
echo "Now you can access to https://${myIP}:8443/console/ with the \"developer\" user"
echo
# set iptables rule
iptables -I INPUT -i docker0 -j ACCEPT

sleep 5
oc get pods -n my-app --watch
