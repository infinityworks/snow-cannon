# Terraforming Snowflake
This repo applies an infrastructure as code approach to Snowflake.

Snowflake infrastructure is created and owned by the `SYSADMIN` role and role based access control is administered by the `SECURITYADMIN` role.


## Getting started
### Dependencies
In order to contribute or run this project, you will need:

- [terraform v0.12](https://www.terraform.io/)
- [terraform-provider-snowflake](https://github.com/chanzuckerberg/terraform-provider-snowflake)
- [Docker](https://www.docker.com/)
- [pre-commit](https://pre-commit.com/)


### Installing Terraform Snowflake Provider
The simplest way to install the third-party Snowflake provider is by executing the following:

    curl https://raw.githubusercontent.com/AdamDewberry/terraform-provider-snowflake/master/download.sh |bash -s -- -b $HOME/.terraform.d/plugins

**Note: There is a minor error in the master branch for file `download.sh`; I have submitted a PR correcting this and currently only the file from the forked branch above is valid.**

### Setting your ENV VARS
This project depends on user authentication by environment variables. Each session will require these to be set which is why we will create a convenient file which will load them in.

First we will store a local copy of your credentials for ease of export.

Edit and run the following command with your Snowflake username and password to create a Snowflake credentials file within `~/.snowflake/`.

    echo "SNOWFLAKE_USER=\nSNOWFLAKE_PASSWORD=" > ~/.snowflake/credentials

for example:

    echo "SNOWFLAKE_USER=IW_USER\nSNOWFLAKE_PASSWORD=TheresNeverTooMuchData" > ~/.snowflake/credentials

Once this credentials file has been created, run the following command to set your env vars:

    eval $(./credentials.sh)

Remeber to execute this `eval` statement for each session.

### Pre-commit Hooks

This project uses pre-commit hooks as a means to keep code readable, and as one of our measures to prevent broken code from being rolled out.

Before writing code for the first time, make sure to initialise the hooks:

    pre-commit install

From now on, pre-commit checks will be run any time you make a commit on the project.

You may also optionally run these checks against all extant files in the project:


    pre-commit run --all-files

**Important note: if your code fails pre-commit checks, your commit will be cancelled. You'll need to fix the issues and commit again.**

## Rolling out changes

Change into the directory of the resource type you want to create. For example, rbac:

    cd rbac

Then

    terraform init
    terraform plan

If you're happy with the output

    terraform apply


Then tidy up after yourself:


    rm -rf .terraform


# Deploying this project

Some resources are dependent on others already existing, thus we must deploy the resources in a specific order. They have not been linked through modules and outputs as this causes deployment and destruction conflicts; for example, a non-existing database would be created if a schema linked to it was created first, this would mean the state information for the database is in the schema state file and we cannot independently modify the database - therefore they are referred to as variables since snowflake looks for existence of names, not IDs.

The deployment order is as follows:
1. Databases
1. Schemas
1. Integrations
1. External Stages
1. Add Snowflake External ID to AWS IAM role
1. Pipes


## Creating the data lake

To create the data lake, change into the `/aws` directory and execute:

    terraform init -backend=true -backend-config=backend-config.tfvars
    terraform plan -var-file=environment.tfvars

If all is well and the expected resources are available, run:

    terraform apply -var-file=environment.tfvars

After you've finished terraforming, remove the `.terraform` directory and its contents.

    rm -rf .terraform
