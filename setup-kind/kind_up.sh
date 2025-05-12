#!/bin/bash

cd $(dirname ${BASH_SOURCE})

set -e

# kind delete clusters --all

hub=${HUB:-hub}
c1=${CLUSTER1:-cluster1}
c2=${CLUSTER1:-cluster2}

hubctx="kind-${hub}"
c1ctx="kind-${c1}"
c2ctx="kind-${c2}"

kind create cluster --name "${hub}"
kind create cluster --name "${c1}" --config cluster1-config.yaml
kind create cluster --name "${c2}" --config cluster2-config.yaml

echo 
echo 
echo "kind get kubeconfig --name hub  > /tmp/hub-io-kubeconfig"
echo "export KUBECONFIG=/tmp/hub-io-kubeconfig"
echo 
echo 
echo "kind get kubeconfig --name cluster1 > /tmp/cluster1-io-kubeconfig"
echo "export KUBECONFIG=/tmp/cluster1-io-kubeconfig"
echo 
echo 
echo "kind get kubeconfig --name cluster2 > /tmp/cluster2-io-kubeconfig"
echo "export KUBECONFIG=/tmp/cluster2-io-kubeconfig"
echo 
echo 
