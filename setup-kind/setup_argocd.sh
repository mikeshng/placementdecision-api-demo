#!/bin/bash
set -e

kind export kubeconfig --name hub

# login to Argo CD
echo "Login to Argo CD"
admin_pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d)
argocd login localhost:8080 --username=admin --password="${admin_pass}" --insecure

# register the two OCM managed clusters to Argo CD
echo "Register cluster1 and cluster2 to Argo CD"
argocd cluster add kind-cluster1 --name=cluster1
argocd cluster add kind-cluster2 --name=cluster2

argocd cluster list
