# PlacementDecision API + Argo CD Demo

Demo for SIG Multicluster PlacementDecision API.

See https://docs.google.com/document/d/1seK6W_TgSDinogXqEm8bOgFCuKqJ9_qkZdodfkSheUY/edit?usp=sharing for more details.

### Create KinD clusters

Edit the IPs in `cluster1-config.yaml` and `cluster2-config.yaml`.

```
cd setup-kind
./kind_up.sh
```

### Install Argo CD CLI

https://argo-cd.readthedocs.io/en/stable/cli_installation/

For example:

```
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

### Install Argo CD on Hub Cluster

https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd/

For example:

```
kind export kubeconfig --name hub
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd rollout status deploy argocd-server --timeout=180s
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Add KinD Clusters to Argo CD Cluster Inventory

```
cd setup-kind
./setup_argocd.sh
```

### Apply Setup Manifests

```
kubectl apply -f manifests/crd/multicluster.x-k8s.io_placementdecisions.yaml
kubectl apply -f manifests/argocd-generator
```

### Apply PlacementDecision and Argo CD Sample AppSet

```
kubectl apply -f manifests/placementdecision.yaml
kubectl apply -f manifests/guestbook-appset.yaml
```

### Update PlacementDecision

App to cluster1:

```
kubectl -n argocd patch placementdecision app-placement-decision-1 --type=merge --subresource=status \
  -p '{
    "status": {
      "decisions": [
        {
          "clusterName": "cluster1",
          "reason": ""
        }
      ]
    }
  }'
```

App to cluster1 and cluster2:

```
kubectl -n argocd patch placementdecision app-placement-decision-1 --type=merge --subresource=status \
  -p '{
    "status": {
      "decisions": [
        {
          "clusterName": "cluster1",
          "reason": ""
        },
        {
          "clusterName": "cluster2",
          "reason": ""
        }
      ]
    }
  }'
```
