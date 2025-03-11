# Setup  secure OIDC authentication to AWS
- Open aws **IAM**
- Select ``Identity providers`` click on ``add provider``
- Provider type as ``OpenID Connect``
- **provider url** as ``https://token.actions.githubusercontent.com``
- **Audience** as ``sts.amazonaws.com``
- Finally click on **add provider** button

Next action is to create a role with any name and provide required policies for the required access. NOTE: this is the role arn which github actions will use to login and access resources in aws account.

### Creating a role
- Select ``role`` option in IAM
- Select as ``create role`` and select web identityas ``trusted entity type``
- In **web identity** drop down select the identity you have created as ``token.actions.githubusercontent.com``
- In Audience drop down select as ``sts.amazonaws.com``
- Now in GitHub orgnization type the org name. repo name is optional only select if you want only one repo to be able to connect to aws. If only org is selected, all repo will have access to aws auth.
- Click on next button and select a policy ( custom policy or any existing)
- For lab purpose i am using ``AdministratorAccess`` which is not a secure and provides full account access.

**Example of actions workflow:-**
```yaml
name: aws role auth
on:
  push:
    branches:
    - main
    paths:
      - .github/** 
env:
  AWS_REGION : "us-east-1"
permissions:
      id-token: write   # This is required for requesting the JWT
      contents: read    # This is required for actions/checkout
jobs:
  my_job:
    name: deploy to staging
    runs-on: ubuntu-latest
    steps:
      - name: Git clone the repository
        uses: actions/checkout@v3
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v4.1.0
        with:
          role-to-assume: arn:aws:iam::430118834478:role/gh_assume_role
          aws-region: ${{ env.AWS_REGION }}
      - name: Sts GetCallerIdentity
        run: |
          aws sts get-caller-identity
          aws s3 ls
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          registry: 430118834478.dkr.ecr.us-east-1.amazonaws.com
      - name: build and push
        run: |
          docker pull nginx:1.24
          docker tag nginx:1.24 430118834478.dkr.ecr.us-east-1.amazonaws.com/demo:latest
          docker push 430118834478.dkr.ecr.us-east-1.amazonaws.com/demo:latest
         
```
