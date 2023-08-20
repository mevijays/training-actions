# Actions runner controller deployment with kind cluster.
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
    - containerPort: 80
      hostPort: 80
      listenAddress: "0.0.0.0"
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      listenAddress: "0.0.0.0"
      protocol: TCP
    - containerPort: 2379
      hostPort: 2379
      listenAddress: "127.0.0.1"
      protocol: TCP
    - containerPort: 30000
      hostPort: 30000
      listenAddress: "0.0.0.0"
      protocol: TCP
    - containerPort: 30001
      hostPort: 30001
      listenAddress: "0.0.0.0"
      protocol: TCP
    - containerPort: 30002
      hostPort: 30002
      listenAddress: "0.0.0.0"
      protocol: TCP
    kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "ingress-ready=true"
networking:
  kubeProxyMode: "ipvs"
  apiServerAddress: "127.0.0.1"
  apiServerPort: 6443

```
Install cert manager

```yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.1/cert-manager.yaml
```
Now install the controller   
```yaml
kubectl apply -f https://github.com/actions/actions-runner-controller/releases/download/v0.22.0/actions-runner-controller.yaml --server-side
```
Now create github token with minimum repo admin permission and create a secret

```yaml
kubectl create secret generic controller-manager -n actions-runner-system --from-literal=github_token=ghp_xxxxkjkjdsd
```
Now create runner config. i am creating dind runner here

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: gh-runner
spec:
  replicas: 2
  template:
    spec:
      organization: mevijays
      image: summerwind/actions-runner-dind
      dockerdWithinRunnerContainer: true
      labels: [ dind ]
```
Deploy now

```yaml
kubectl apply -f ghrunner.yaml
```

