# Understanding GitHub Actions
## Overview
GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline.  
## The components of GitHub Actions
You can configure a GitHub Actions workflow to be triggered when an event occurs in your repository, such as a pull request being opened or an issue being created. Your workflow contains one or more jobs which can run in sequential order or in parallel. Each job will run inside its own virtual machine runner, or inside a container, and has one or more steps that either run a script that you define or run an action.
### Workflows
A workflow is a configurable automated process that will run one or more jobs. Workflows are defined by a YAML file checked in to your repository 

Workflows are defined in the .github/workflows directory in a repository, and a repository can have multiple workflows.

### Events
An event is a specific activity in a repository that triggers a workflow run. For example, activity can originate from GitHub when someone creates a pull request, opens an issue, or pushes a commit to a repository. You can also trigger a workflow to run on a schedule.

### Jobs
A job is a set of steps in a workflow that is executed on the same runner. Each step is either a shell script that will be executed, or an action that will be run. Steps are executed in order and are dependent on each other. Since each step is executed on the same runner, you can share data from one step to another.

You can configure a job's dependencies with other jobs; by default, jobs have no dependencies and run in parallel with each other

### Actions
An action is a custom application for the GitHub Actions platform that performs a complex but frequently repeated task. Use an action to help reduce the amount of repetitive code that you write in your workflow files.  

There are many actions from GitHub which we use to simplify our workflow and many from third party community developers.

### Runners
A runner is a server that runs your workflows when they're triggered. Each runner can run a single job at a time.   
There are manly two types of runner.
- **SelfHosted runner**. These are custom runners which you creates for your repository/orgnization use.
- **GitHUb runner**. These are free runners from GitHub itself.   

Runners can be called by its label.

## Create an example workflow
GitHub Actions uses YAML syntax to define the workflow. Each workflow is stored as a separate YAML file in your code repository, in a directory named ```.github/workflows.```.   

- In your repository, create the .github/workflows/ directory to store your workflow files.

- In the .github/workflows/ directory, create a new file called learn-github-actions.yml and add the following code.  

```yaml
name: learn-github-actions
run-name: ${{ github.actor }} is learning GitHub Actions
on: [push]
jobs:
  check-bats-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v3
        with:
          node-version: '14'
      - run: npm install -g bats
      - run: bats -v

```

## Understanding the workflow file
To help you understand how YAML syntax is used to create a workflow file, this section explains each line of the introduction's example:


```
name: learn-github-actions
```
Optional - The name of the workflow as it will appear in the "Actions" tab of the GitHub repository. If this field is omitted, the name of the workflow file will be used instead.
```
run-name: ${{ github.actor }} is learning GitHub Actions
```
Optional - The name for workflow runs generated from the workflow, which will appear in the list of workflow runs on your repository's "Actions" tab. This example uses an expression with the github context to display the username of the actor that triggered the workflow run. For more information, see "Workflow syntax for GitHub Actions."

```
on: [push]
```
Specifies the trigger for this workflow. This example uses the push event, so a workflow run is triggered every time someone pushes a change to the repository or merges a pull request. This is triggered by a push to every branch; for examples of syntax that runs only on pushes to specific branches, paths, or tags, see "Workflow syntax for GitHub Actions."

```
    jobs:
```
Groups together all the jobs that run in the learn-github-actions workflow.

 ```
         check-bats-version:
```
Defines a job named check-bats-version. The child keys will define properties of the job.
```
    runs-on: ubuntu-latest
```
Configures the job to run on the latest version of an Ubuntu Linux runner. This means that the job will execute on a fresh virtual machine hosted by GitHub. For syntax examples using other runners, see "Workflow syntax for GitHub Actions"

    steps:
Groups together all the steps that run in the check-bats-version job. Each item nested under this section is a separate action or shell script.

      - uses: actions/checkout@v4
The uses keyword specifies that this step will run v4 of the actions/checkout action. This is an action that checks out your repository onto the runner, allowing you to run scripts or other actions against your code (such as build and test tools). You should use the checkout action any time your workflow will use the repository's code.

      - uses: actions/setup-node@v3
        with:
          node-version: '14'
This step uses the actions/setup-node@v3 action to install the specified version of the Node.js. (This example uses version 14.) This puts both the node and npm commands in your PATH.

      - run: npm install -g bats
The run keyword tells the job to execute a command on the runner. In this case, you are using npm to install the bats software testing package.

      - run: bats -v
Finally, you'll run the bats command with a parameter that outputs the software version.