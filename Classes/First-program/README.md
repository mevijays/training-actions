# First actions workflow
```yaml
name: first job
on: [workflow_dispatch]
jobs:
  greeting_job:
    runs-on: ubuntu-latest
    steps:
      - name: "Say Hello"
        run: echo "Hello World!"
```
- Store output in workspace variable
```yaml
name: first job
on: [workflow_dispatch]
jobs:
  greeting_job:
    runs-on: ubuntu-latest
    steps:
      - name: "Say Hello"
        id: hello
        run: echo "test=Hello World!" >> "$GITHUB_OUTPUT"
      - name: "printenv"
        run: env
```

- print output in workspace summery
```yaml
name: first job
on: [workflow_dispatch]
jobs:
  greeting_job:
    runs-on: ubuntu-latest
    steps:
      - name: "Say Hello"
        run: echo "Hello World!"
      - name: Adding markdown
        run: echo '### Hello world! 🚀' >> $GITHUB_STEP_SUMMARY
```

