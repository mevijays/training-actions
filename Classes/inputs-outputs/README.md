# Inputs and outputs

## Using inputs and outputs with an action
An action often accepts or requires inputs and generates outputs that you can use. For example, an action might require you to specify a path to a file, the name of a label, or other data it will use as part of the action processing.

- **Example LAB:**.  
I have to run 2 workflow.
   - workflow 1 takes the run number and run id and prints in output so that when we are calling this workflow  from another workflow , we can use this output there in any form.
   - Then in workflow 2   it takes msg1 and msg2 as 2 inputs and prints it.
   - Now since both above workflows are re-usable, i will create a third one where i will be  calling both workflow 1 and workflow 2 where i will use msg1 input as output of workflow1 

- **Solution:**  

Workflow1:
```yaml
name: 'jar build'
on:
  workflow_call:
    outputs:
      msgout: 
        value: ${{ jobs.job1.outputs.output1 }}
jobs:
  job1:
    runs-on: mylab-vm
    outputs:
      output1: ${{ steps.step1.outputs.test }}
    steps:
      - name: step1
        id: step1
        run: echo test=${{ github.run_number }}-${{ github.run_id }} >> $GITHUB_OUTPUT
```

Workflow2:   

```yaml
name: 'docker build'
on:
  workflow_call:
    inputs:
      msg1: 
        type: string
        default: "hello"
      msg2:
        type: string
        default: "vijay"
jobs:
  job2:
    runs-on: mylab-vm
    steps:
      - name: step1
        id: step1
        run: echo ${{ inputs.msg1 }}--${{ inputs.msg2 }}
```

Main workflow:  
```yaml
name: Call a reusable

on:
  workflow_dispatch:
  repository_dispatch:
    types: [hitme]

jobs:
  ijob:
    uses: mevijays/test-actions/.github/workflows/workflow1.yml@main

  job2:
    uses: mevijays/test-actions/.github/workflows/workflow2.yml@main
    needs: ijob
    with:
       msg1: ${{ needs.ijob.outputs.msgout }}
       msg2: 'My system'
```