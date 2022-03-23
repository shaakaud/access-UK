#!/bin/bash

################################################################################
#Author: udaytj@versa-networks.com
#Usage:
#~/bin/chclus.sh -c gke
#~/bin/chclus.sh -c hedc
################################################################################


helpFunction()
{
   echo ""
   echo "Usage: $0 -c cluster"
   echo -e "\t-c Name of the cluster"
   exit 1 # Exit script after printing help
}

while getopts "c:" opt
do
   case "$opt" in
      c ) cluster="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$cluster" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

echo "Cluster: $cluster"
echo

export KUBECONFIG=$HOME/gcp-ws/kube-config/kube_config
if [ $cluster = "hedc" ]; then
    kubectl config --kubeconfig=$KUBECONFIG use-context kubernetes-admin@kubernetes
elif [ $cluster = "gke" ]; then
    kubectl config --kubeconfig=$KUBECONFIG use-context gke_uday-msb-2_us-central1_example-cluster
fi


