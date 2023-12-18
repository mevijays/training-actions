## Environment uses in actions

To set a custom environment variable for a single workflow, you can define it using the env key in the workflow file. The scope of a custom variable set by this method is limited to the element in which it is defined.    
Example:
```yaml
name: Greeting on variable day

on:
  workflow_dispatch

env:
  DAY_OF_WEEK: Monday

jobs:
  greeting_job:
    runs-on: ubuntu-latest
    env:
      Greeting: Hello
    steps:
      - name: "Say Hello Mona it's Monday"
        env:
          First_Name: Mona
        run: echo "$Greeting $First_Name. Today is $DAY_OF_WEEK!"
``` 
## Using the env context to access environment variable values
In addition to runner environment variables, GitHub Actions allows you to set and read env key values using contexts. Environment variables and contexts are intended for use at different points in the workflow.

```yaml
env:
  DAY_OF_WEEK: Monday

jobs:
  greeting_job:
    runs-on: ubuntu-latest
    env:
      Greeting: Hello
    steps:
      - name: "Say Hello Mona it's Monday"
        if: ${{ env.DAY_OF_WEEK == 'Monday' }}
        run: echo "$Greeting $First_Name. Today is $DAY_OF_WEEK!"
        env:
          First_Name: Mona

```
In this modification of the earlier example, we've introduced an if conditional. The workflow step is now only run if DAY_OF_WEEK is set to "Monday".   
We could, however, have chosen to interpolate those variables before sending the job to the runner, by using contexts. The resulting output would be the same.
```yaml
run: echo "${{ env.Greeting }} ${{ env.First_Name }}. Today is ${{ env.DAY_OF_WEEK }}!"
```
**Note:** Contexts are usually denoted using the dollar sign and curly braces, as ``${{ context.property }}``. In an if conditional, the ${{ and }} are optional, but if you use them they must enclose the entire comparison statement, as shown above.
