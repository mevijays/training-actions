## Create NS and deploy controller.
```bash
NAMESPACE="arc-systems"
helm install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```
## Configure runner set
```bash
INSTALLATION_NAME="arc-runner-set"
NAMESPACE="arc-runners"
GITHUB_CONFIG_URL="https://github.com/<your_enterprise/org/repo>"
GITHUB_PAT="<PAT>"
helm install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```
if the DIND runner has to be provisioned. update [values.yaml](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml) with bellow.

Docker-in-Docker mode is a configuration that allows you to run Docker inside a Docker container. In this configuration, for each runner pod created, ARC creates the following containers.

- An ``init`` container
- A ``runner`` container
- A ``dind`` container
To enable Docker-in-Docker mode, set the containerMode.type to dind as follows.
```yaml
containerMode:
  type: "dind"
```
The template.spec will be updated to the following default configuration.
```yaml
template:
  spec:
    initContainers:
      - name: init-dind-externals
        image: ghcr.io/actions/actions-runner:latest
        command:
          ["cp", "-r", "/home/runner/externals/.", "/home/runner/tmpDir/"]
        volumeMounts:
          - name: dind-externals
            mountPath: /home/runner/tmpDir
    containers:
      - name: runner
        image: ghcr.io/actions/actions-runner:latest
        command: ["/home/runner/run.sh"]
        env:
          - name: DOCKER_HOST
            value: unix:///var/run/docker.sock
        volumeMounts:
          - name: work
            mountPath: /home/runner/_work
          - name: dind-sock
            mountPath: /var/run
      - name: dind
        image: docker:dind
        args:
          - dockerd
          - --host=unix:///var/run/docker.sock
          - --group=$(DOCKER_GROUP_GID)
        env:
          - name: DOCKER_GROUP_GID
            value: "123"
        securityContext:
          privileged: true
        volumeMounts:
          - name: work
            mountPath: /home/runner/_work
          - name: dind-sock
            mountPath: /var/run
          - name: dind-externals
            mountPath: /home/runner/externals
    volumes:
      - name: work
        emptyDir: {}
      - name: dind-sock
        emptyDir: {}
      - name: dind-externals
        emptyDir: {}
```
The values in ``template.spec`` are automatically injected and cannot be overridden. If you want to customize this setup, you must unset containerMode.type, then copy this configuration and apply it directly in your copy of the values.yaml file.
