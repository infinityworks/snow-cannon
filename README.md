<h1 align="left">Terraforming Snowflake</h1>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Getting started](#getting-started)
  - [Dependencies](#dependencies)
  - [Installing Terraform Snowflake Provider](#installing-terraform-snowflake-provider)
  - [Pre-commit Hooks](#pre-commit-hooks)
  - [Setting your ENV VARS](#setting-your-env-vars)
- [Creating Infrastructure](#creating-infrastructure)
  - [Remote state and lock table](#remote-state-and-lock-table)
  - [Provisioning Snowflake resources](#provisioning-snowflake-resources)
  - [Creating Snowpipes](#creating-snowpipes)
    - [The Specifics](#the-specifics)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

This repo applies an infrastructure as code approach to deploying Snowflake resources using Terraform. It relies on the [open source provider by the Chan Zuckerberg Institute](https://github.com/chanzuckerberg/terraform-provider-snowflake) and can create, alter and destroy users, roles and resources in Snowflake.

Making use of Snowflake's default and recommended roles, this project creates the majority of infrastructure with the `SYSADMIN` role, users and roles are administered by the `SECURITYADMIN` role, and account integrations and related resources are owned by the `ACCOUNTADMIN` role.

# Getting started
## Dependencies
In order to contribute or run this project, you will need:

- [terraform v0.12](https://www.terraform.io/)
- [terraform-provider-snowflake](https://github.com/chanzuckerberg/terraform-provider-snowflake)
- [AWS Command Line Interface](https://aws.amazon.com/cli/)
- [pre-commit](https://pre-commit.com/)


## Installing Terraform Snowflake Provider
The simplest way to install the third-party Snowflake provider is by executing the following command:

    curl https://raw.githubusercontent.com/chanzuckerberg/terraform-provider-snowflake/master/download.sh |bash -s -- -b $HOME/.terraform.d/plugins

## Pre-commit Hooks

This project uses pre-commit hooks as a means to keep code readable and a measure to prevent broken code from being rolled out.

Before committing code for the first time, make sure to initialise the hooks:

    pre-commit install

From now on, pre-commit checks will be run any time you make a commit on the project.

You may also optionally run these checks against all extant files in the project:

    pre-commit run --all-files

**Important note: if your code fails pre-commit checks, your commit will be cancelled. You'll need to fix the issues and commit again.**

## Setting your ENV VARS
This project depends on user authentication by environment variables; to simplify this process we will create a convenient file to load them.

Edit and run the following command including your Snowflake username and password, to create a Snowflake credentials file within `~/.snowflake/`.

    echo "SNOWFLAKE_USER=\nSNOWFLAKE_PASSWORD=" > ~/.snowflake/credentials

for example:

    echo "SNOWFLAKE_USER=USER1\nSNOWFLAKE_PASSWORD=TheresNeverTooMuchData" > ~/.snowflake/credentials

Once this file has been created, run the following to set your env vars:

    eval $(./credentials.sh)

Remember to execute this `eval` statement for each terminal window you are working in.

# Creating Infrastructure

## Remote state and lock table
To begin we must create a remote state bucket and lock table within an AWS account; this is referenced to keep track of all changes made by Terraform and ensures stateful deployments.

The remote stage bucket and lock table's name are comprised of your project name, this can be updated in `./aws/static_resources/S3/environment/environment.tfvars`. After authenticating a local session to your AWS account, navigate to `./aws/static_resources/S3` and execute:

    terraform init
    terraform plan -var-file=environment/environment.tfvars -out=tfplan  
    terraform apply tfplan
    rm -r .terraform && rm tfplan   

This will create a remote state bucket with the name `<your-project>-remote-state`. Next for the lock table, again changing the `environment.tfvars` project name:

    cd ../dynamoDB
    terraform init
    terraform plan -var-file=environment/environment.tfvars -out=tfplan  
    terraform apply tfplan
    rm -r .terraform && rm tfplan   

Check with the CLI that `<your-project>-lock-table` now exists.

Now we have our state infrastructure we can begin Terraforming Snowflake and its AWS counterparts.

## Provisioning Snowflake resources
Some resources are dependent on others already existing, for example schemas belong to databases, and stages belong to a schema within a database; thus we must deploy resources in a specific order. They have not been linked through modules and outputs as this causes deployment and destruction conflicts; for example, a non-existing database would be created if a schema linked to it was created first, this would mean the state information for the database is in the schema state file and we cannot independently modify said database - therefore they are referred to as variables since snowflake appears to look for existence of names, not IDs. With this knowledge we must respect a deployment order:

1. RBAC
1. Databases
1. Schemas
1. Integrations
1. Stage
1. Pipes

Each directory containing a resource type has an associated `main.tf` file which declares the provider; this provider includes the Snowflake account name, region and role which is adopted to create, modify and destroy infra. You must ensure you can adopt the appropriate roles required.

To create users and roles, navigate to `./Snowflake/rbac/` and run:

    terraform init -backend=true -backend-config=environment/backend-config.tfvars
    terraform plan -var-file=environment/environment.tfvars -out=tfplan  
    terraform apply tfplan
    rm -r .terraform && rm tfplan

This pattern of initialisation, planning and deployment is repeated across each directory to create resources.

Try creating a warehouse.

## Creating Snowpipes
Creating roles, databases and warehouses are easy, creating Snowpipes requires a little finesse. The following summaries the steps, though the specifics which follow must be observed.
- First we must create a database and schema where an external stage can live.
- Next we require an account integration to connect to an external AWS account.
- Once this has been established we can create the external stage, which is dependent on the account integration.
- If you do not have an existing S3 bucket / data lake to connect to, you must create this from the `./aws/S3/` directory, along with its associated IAM role in `./aws/iam/`.
- Now you can create the Snowpipe.
- The new pipe's SQS ARN is used in configuring the S3 event notifications, at which point we can begin ingesting data.


### The Specifics
Resources that depend on the existence of others have been included as variables within each `environment/environment.tfvars` file. Currently these values can be seen as _hard coded_ but are consistent across each file and are easy to modify and update.

Once a database and schema has been created, in order to create a cloud account integration you must change the variables in `snowflake/infra/storage_integrations/environment/environment.tfvars`, this includes your AWS cloud ID and the S3 IAM role associated with the bucket you wish to connect a pipe to. Note that these parameters are referenced by name and not ID, meaning they can be set in Snowflake before their existence in AWS, providing you are certain of the IAM role name.

Next create the external stage which depends on this integration.

Snowpipe requires a target table to store data in, the simplest way to create this is in the console as follows:

    USE DATABASE <target-database>;
    USE SCHEMA <target-schema>;
    CREATE OR REPLACE TABLE <table-name> (<DDL STATEMENT>);

Before we create the pipe, an S3 bucket and IAM role are required, these are the parameters defined in the integration. If the AWS resources do not exist, you can now create them. We cannot yet set the `bucket_notification` as we do not have the SQS ARN and so do not include this resource block when deploying.

    terraform init -backend=true -backend-config=environment/backend-config.tfvars
    terraform plan -var-file=environment/environment.tfvars -out=tfplan  
    terraform apply tfplan
    rm -r .terraform

Note that the object-creation event has not been configured, we require a parameter from the pipe in order to do this.

In Snowflake run `DESC PIPE <PIPE-NAME>;` and copy the entire `notification_channel` output; this arn should then be included for the key `snowpipe_queue_arn` in `aws/S3/environment/environment.tfvars`; re-run the terraform:

    terraform init -backend=true -backend-config=environment/backend-config.tfvars
    terraform plan -var-file=environment/environment.tfvars -out=tfplan  
    terraform apply tfplan
    rm -r .terraform && rm tfplan

Your pipe should now be configured and you can check its status with:

    SELECT system$pipe_status('"ANALYTICS"."PUBLIC"."DATA_LAKE_PIPE"');

As you load files into the S3 bucket, these will now be consumed into the snowflake table.

Note: If you modify or recreate the account integration, a new `snowflake_external_id` will be generated; the steps on creating a Snowpipe will need to be repeated.
