# jenkins job migration to GitHub actions.
Install docker first as prerequisite... to the migration agent vm.

```bash
curl https://get.docker.com | bash
```
Paginated Builds plugin should be installed on jenkins

- Install the github cli 
```bash
apt install gh -y
```
- Perform a login
```bash
gh auth login 
```
- install the importer extention and update it.
```bash
gh extension install github/gh-actions-importer
gh actions-importer update
```
- Get ready with github PAT, jenkins PAT and jenkins url,usr then configure it,
```bash
gh actions-importer configure
```
- you can perform an audit of jenkins 
```bash
 gh actions-importer audit jenkins --output-dir ./audit-results
```

- can run a dry-run now
```bash
 gh actions-importer dry-run jenkins --source-url https://jenkins.mevijay.dev/job/build/ --output-dir ./dry-run-results
```
- bello is migration task command with example. replace jenkins url and github url
```bash
 gh actions-importer migrate jenkins --source-url https://jenkins.mevijay.dev/job/build/ --target-url https://github.com/mevijays/hello-java --output-dir ./migrate-results
```
### Bulk migration
You can create a yaml with mapping for large migrations.

 ```yaml
 jobs:
  - jenkins_url: "https://jenkins.mevijay.dev/job/build1/"
    github_url: "https://github.com/mevijays/hello-java"
  - jenkins_url: "https://jenkins.mevijay.dev/job/build2/"
    github_url: "https://github.com/mevijays/hello-java"
 ```
 then can write a shell script like this-
 ```bash
#!/bin/bash

# Function to parse YAML file
parse_yaml() {
    local prefix=$2
    local s
    local var
    local value
    s=$(sed -ne "s|^\([[:space:]]*\)\?\([a-zA-Z0-9_]*\): \(.*\)|\1\2=\3|p" "$1")
    while IFS='=' read -r var value; do
        eval "${prefix}${var// /_}=\"${value//\"/\\\"}\""
    done <<< "$s"
}

# Load the YAML file
parse_yaml jobs.yaml "job_"

# Loop through jobs and run the migration command
for i in $(seq 0 $((${job_jobs[@]: -1}))); do
    jenkins_url=${job_jobs[$i].jenkins_url}
    github_url=${job_jobs[$i].github_url}
    
    echo "Migrating job from $jenkins_url to $github_url..."
    
    gh actions-importer migrate jenkins --source-url "$jenkins_url" --target-url "$github_url" --output-dir ./migrate-results
done
 ```

 or perhaps a python would be more easy 

 ```python

 import yaml
import subprocess

# Load the YAML file
with open('jobs.yaml', 'r') as file:
    jobs = yaml.safe_load(file)

# Loop through jobs and run the migration command
for job in jobs['jobs']:
    jenkins_url = job['jenkins_url']
    github_url = job['github_url']
    
    print(f"Migrating job from {jenkins_url} to {github_url}...")
    
    # Construct the command
    command = [
        'gh', 'actions-importer', 'migrate', 'jenkins',
        '--source-url', jenkins_url,
        '--target-url', github_url,
        '--output-dir', './migrate-results'
    ]
    
    # Execute the command
    subprocess.run(command)
 ```
 just need to install yaml 
 ```bash
 pip install pyyaml
 ```
