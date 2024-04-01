#!/bin/bash

################################################################################
#Author: udaytj@versa-networks.com
#Usage:
#export KUBECONFIG=$HOME/gcp-ws/kube-config/kube_config_***
#~/bin/chclus.sh -c gke
#~/bin/chclus.sh -c vgke
#~/bin/chclus.sh -c kblab
#~/bin/chclus.sh -c vlab1
#~/bin/chclus.sh -c devbm1
#~/bin/chclus.sh -c devbm2
#~/bin/chclus.sh -c vprod
#~/bin/chclus.sh -c vinline
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
if [ $cluster = "uklab" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_uklab  use-context kubernetes-admin@kubernetes
elif [ $cluster = "kblab" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_kblab  use-context kubernetes-admin@kubernetes
elif [ $cluster = "gke" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_uday_msb_2 use-context gke_uday-msb-2_us-central1_apidp-cluster
elif [ $cluster = "vgke" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_udaytj_apidp_1 use-context gke_udaytj-apidp-1_us-central1_apidp-cluster
elif [ $cluster = "vlab1" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_vlab1 use-context kubernetes-admin@kubernetes
elif [ $cluster = "devbm1" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_devbm1 use-context kubernetes-admin@kubernetes
elif [ $cluster = "devbm2" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_devbm2 use-context kubernetes-admin@kubernetes
elif [ $cluster = "vprod" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_vprod use-context kubernetes-admin@kubernetes
elif [ $cluster = "vinline" ]; then
    kubectl config --kubeconfig=$HOME/gcp-ws/kube-config/kube_config_vinline use-context kubernetes-admin@kubernetes
fi
