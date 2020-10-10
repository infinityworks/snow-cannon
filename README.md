<h1 align="left">Terraforming Snowflake</h1>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Getting started](#getting-started)
  - [Dependencies](#dependencies)
  - [Installing SnowSQL](#installing-snowsql)
  - [Setting your ENV VARS](#setting-your-env-vars)
  - [Pre-commit Hooks](#pre-commit-hooks)
- [Creating Infrastructure](#creating-infrastructure)
  - [Workspaces](#workspaces)
    - [Creating and selecting a workspace](#creating-and-selecting-a-workspace)
  - [Remote state and lock table](#remote-state-and-lock-table)
  - [Provisioning Snowflake resources](#provisioning-snowflake-resources)
    - [Modules](#modules)
  - [Users](#users)
  - [Roles](#roles)
  - [Databases and schemas](#databases-and-schemas)
  - [Creating Snowpipes](#creating-snowpipes)
    - [Checking a pipes status](#checking-a-pipes-status)
    - [Pipe module design](#pipe-module-design)
    - [Pipe dependencies](#pipe-dependencies)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

This repo applies an infrastructure as code approach to deploying Snowflake resources using Terraform. It relies on the [open source provider by the Chan Zuckerberg Initiative](https://github.com/chanzuckerberg/terraform-provider-snowflake) and can create, alter and destroy users, roles and resources in Snowflake.

Making use of Snowflake's default and recommended roles, this project creates the majority of infrastructure with the `SYSADMIN` role, users and roles are administered by the `SECURITYADMIN` role, and account integrations and related resources are owned by the `ACCOUNTADMIN` role.

# Getting started
## Dependencies
In order to contribute or run this project, you will need:

- [terraform v0.13](https://www.terraform.io/)
- [terraform-provider-snowflake v0.17.1](https://github.com/chanzuckerberg/terraform-provider-snowflake)
- [Python v3.7](https://www.python.org/downloads/release/python-381/)
- [SnowSQL v1.2](https://docs.snowflake.com/en/user-guide/snowsql.html)
- [AWS Command Line Interface v2.0.46](https://aws.amazon.com/cli/)
- [pre-commit](https://pre-commit.com/)

## Installing SnowSQL
The project uses the SnowSQL CLI for resource creation when the Terraform provider lacks the functionality; this includes table creation particularly when deploying Snowpipes. To download SnowSQL cli follow [these instructions](https://docs.snowflake.com/en/user-guide/snowsql-install-config.html#installing-snowsql) or if you have homebrew use:

    brew cask install snowflake-snowsql

This will also create a config file in `~/.snowsql/config` used for authentication and setting default values such as `role` and `warehouse`.

Edit the file and create a Snowflake profile (connections is the default profile), e.g:

    [connections]
    accountname = myAccout
    region = eu-west-1
    username = YourUserName
    password = YourPass

If you are using multiple Snowflake accounts or users you can create additional profiles in this file using the same structure:

    [connections.iw]
    accountname = infinityworkspartner
    region = eu-west-1
    username = YourUserName
    password = YourPassword


## Setting your ENV VARS
To deploy Snowflake using Terraform, this project depends on user authentication by environment variables; to simplify this process we load the SnowSQL config credentials using a python script; the two env vars outputted are `SNOWFLAKE_USER` and `SNOWFLAKE_PASSWORD`.

The python script accepts two optional arguments, `profile` and `application`; these determine the Snowflake profile you wish to use and the env vars to export. If the flags are not called, they will default to using your `connections` profile and output both terraform and SnowSQL env vars. **The CLI arguments are case sensitive**. The accepted values for `application` are `terraform`, `snowsql` or `all`, for example:

     eval $(python3 load_snowflake_credentials.py --profile connections --application all)

NOTE: This must be run in an `eval $( )` statement as the python script prints your vars to the terminal and `eval` evaluates the export statement, loading them into your environment. **If you do not use the `eval` statement your creds will be printed in plain text to your terminal and not loaded into your environment variables**.

Remember to execute this `eval` statement for each terminal window you are working in.

## Pre-commit Hooks

This project uses pre-commit hooks as a means to keep code readable and a measure to prevent broken code from being rolled out.

[Download pre-commit](https://pre-commit.com/) from their website or use:

    brew install pre-commit

Before committing code for the first time, make sure to initialise the hooks:

    pre-commit install

From now on, pre-commit checks will be run any time you make a commit on the project.

You may also optionally run these checks against all extant files in the project:

    pre-commit run --all-files

**Important note: if your code fails pre-commit checks, your commit will be cancelled. You'll need to fix the issues and commit again.**

# Creating Infrastructure
## Workspaces

Environments are separated using Terraform workspaces. Each workspace has its own remote state file and the module `./terraform-config/` dynamically passes the correct AWS profile and Snowflake account details based upon the workspace selected.

Each environment's config can be added to `terraform-config/providers.tf` and the workspace name must correspond exactly to the environment's map within this file.

    locals {
      environment = {
        dev = {
          name       = "dev"
          group_name = "nonprod"

          aws_account = {
            profile = "aws-dev"
            id      = "xxxxxxxxxxxx"
            region  = "eu-west-2"
          }

          snowflake_account = {
            id     = "infinityworkspartner"
            region = "eu-west-1"
          }
        }
        staging = {
          name       = "staging"
          group_name = "nonprod"

          aws_account = {
            profile = "aws-staging"
            id      = "yyyyyyyyyyyy"
            region  = "eu-west-2"
          }

          snowflake_account = {
            id     = "infinityworkspartnerstaging"
            region = "eu-west-1"
          }
        }
        providers = {
          snowflake_version = "0.17.1"
          aws_version       = "~> 3.5.0"
        }
      }
    }

The AWS profile must also match the credentials profiles you wish to use.

### Creating and selecting a workspace
After initialising Terraform you can create and/or select a workspace. When a workspace is created, it is automatically adopted. To keep things simple, edit the following command with your env name and run the following each time:

    terraform init && terraform workspace new <env> || terraform workspace select <env>
    terraform apply

If the workspace already exists, the follow-up command will select the workspace.

## Remote state and lock table
To begin we must create a remote state bucket and lock table within an AWS account; this is referenced to keep track of all changes made by Terraform and ensures stateful deployments.

The remote state bucket and lock table's name are comprised of your project name, this can be updated in `./aws/state_resources/s3/environment/dev/environment.tfvars`.

To run terraform locally you must have a [valid aws session](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) and [set your `AWS_PROFILE`](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html).

In order to deploy the state bucket, navigate to `./aws/state_resources/s3/` and run:

    terraform init && terraform workspace new dev || terraform workspace select dev
    terraform apply

This will create a remote state bucket with the name `<your-project>-remote-state-<env>`. Next for the lock table, again changing the `environment.tfvars` variables:

    cd ../dynamoDB
    terraform init && terraform workspace new dev || terraform workspace select dev
    terraform apply
    rm -r .terraform && rm tfplan

Check with the aws CLI that `<your-project>-lock-table` now exists:

    aws dynamodb list-tables

Now we have our state infrastructure we can begin Terraforming Snowflake and its AWS counterparts.

## Provisioning Snowflake resources
Some resources are dependent on others already existing, for example schemas belong to databases, and stages belong to a schema within a database; thus we must deploy resources in a specific order:

1. RBAC
1. Warehouses
1. Integrations
1. Databases
1. Schemas
1. Stage
1. Pipes
1. Tasks

Each directory containing a resource has an associated `main.tf` file which declares the provider; this provider includes the Snowflake account name, region and role which is adopted to create, modify and destroy infra. You must ensure you can adopt the appropriate roles required by Snowflake. With an infra as code approach, this project is designed to be deployed across multiple environments using separate accounts; the separation is controlled through configuration with `environment.tfvars` files (though it is possible to deploy `n` environments in a single account by appending resource names with the env).

### Modules
Modules are a key element of what makes this project successful, particularly for automating data ingestion from cloud storage. Modules simplify the work flow and reduce maintenance of groups of resources that depend on each other. For example, the pipes-module will dynamically create the supporting infrastructure of an landing table, account integration, AWS iam role, external stage and the pipe itself, as a one-to-one relationship. Each data flow is decoupled and independent from one another.

Beware, when creating modules they can cause deployment and destruction conflicts; for example, independently **granting permissions** on roles to a resource will conflict with other module deployments as the Terraform provider looks for global permissions and finds the difference; having multiple grant objects will conflict with each other as the sql output is no longer a single source of truth when comparing one Terraform block to another. To avoid this, all resource grant statements much be in a single block.

## Users
To create users navigate to `./Snowflake/rbac/users/` and create a new `.tf` file for each group of users, a recommended approach is to create one file per squad or business area.  Within this file use the provider resource  `snowflake_user` and define the user's preferences:

    resource "snowflake_user" "user_JohnSnow" {
      name                 = "JohnSnow"
      login_name           = "JohnSnow"
      default_role         = "PUBLIC"
      password             = "replace"
      must_change_password = "true"
      comment              = "Data consumer in the wall squad"
    }

To grant the user a role we will reference the user's name from the above resource using Terraform outputs; create an output in `outputs.tf` with the following structure:

    output "JohnSnow_name" {
      value = snowflake_role.user_JohnSnow.name
    }

Including a default role, other than `PUBLIC`, will not automatically grant said role; you must grant the role separately, otherwise a user will not be able to login.

The default password is currently "replace", this must be changed immediately after creation, by the user in the Snowflake console.

**Note:** Any plain text run through Terraform will be stored in the remote state and so a user's chosen password should not be included in Terraform and a generic one is provided; it is recommended to include the flag to force a user to change their password on first login.

Once this block has been written, run:

    terraform init && terraform workspace new dev || terraform workspace select dev
    terraform apply

This pattern of initialisation, planning and deployment is repeated across each directory to create different resources.

## Roles
Roles are created in a similar way to users in `./Snowflake/rbac/roles/`. Each role comes with a grant block which will grant the role created to users or other roles. It is recommended that one role is created per file to maintain separation and ease of organisation.

To persist user changes, for example name or default roles, it is recommended to reference the user's `name` value from the remote state of the user file. This is achieved by the `data` block, `terraform_remote_state`.

**WARNING:** As previously mentioned, grant statements will misbehave if instantiated multiple times to the same object. The provider appears to run a query to find where the grant statement has already been applied and finds the difference to the grant block you are running; this includes removing any granted permissions that were created in the console and not through code using this provider and remote state. It is recommended not to use the resource which grants AccountAdmin, when revoking or destroying it is possible to remove your own role access and lock yourself out.

## Databases and schemas
The above pattern of declaring a resource, referencing the remote state for any dependencies and granting permissions to it is used in other resource creation, such as databases. At a minimum a role must have `usage` granted to access a database.

It is recommended that databases have their own dedicated `.tf` file which includes it's grant statements. Schemas should be separated by directory for each database created:

    ├── schemas
        ├── analytics_db
        │   ├── marketing
        │   ├── sales
        │   └── customer
        └── models_db
            ├── schema1
            ├── schema2
            └── schema3

 ## Creating Snowpipes
 Creating roles, databases and warehouses are easy, creating Snowpipes requires a little finesse. To do the heavy lifting we use modules to abstract all the difficulty and configuration. The Snowpipe module lives in `snowflake/infra/modules/snowpipe-module/` and new pipes are declared in `snowflake/infra/pipes/`. This module creates the landing table, account integration, external stage, iam role, pipe and s3 bucket notification which are required to automate data ingestion. Pipes are decoupled from one another and have their own remote state file, which means you must also update the path and values of `snowflake/infra/pipes/my-new-pipe/environment/backend-config.tfvars` to reflect this. This ensures the pipes and their dependencies are isolated from other pipes.

 The pipe module is designed to consume data from either an entire bucket or a key within a bucket. The name of the key of the bucket is used in naming all the supporting resources and the pipe itself, e.g. for the `finance` key, the pipe would be called `FINANCE_DATA_PIPE`. If a bucket does not have a key and you wish to consume from the top level of the bucket, set `has_key = false` though in this case it will still take the name `FINANCE_DATA_PIPE`. The module variables determines the granularity a pipe can consume from and it's naming.

 The default file format to be consumed is JSON; this can be changed to ingest tabular objects such as CSV files using the following variables:
 - file_format
 - record_delimiter
 - field_delimiter

 The following example shows how to customise your pipe requirements, including the file suffix; the suffix can include characters of the filename but is mainly used to declare the filetype to be consumed.

     module "finance_snowpipe" {
         source           = "../../modules/snowpipe-module/"
         s3_bucket_name   = "marketing-analytics"
         s3_key           = "finance"
         has_key          = false
         file_format      = "CSV"
         field_delimiter  = "\t"
         record_delimiter = "\n"
         filter_suffix    = ".csv"
     }

 For the case of structured data, such as a `.csv` or `.tsv.gz`, you must provide a table definition of the columns and datatype. The structure is:

     field,type
     col1,INTEGER
     col2,VARCHAR
     col3,FLOAT

and is located in the working directory where the pipe is to be created within the file `table-definition.csv`. Terraform will read this and generate the DDL statement for the landing table. In the case of semi-structures data, like JSON, a single column will be created with the Snowflake `variant` datatype.

 All landing tables have a timestamp column to note when the record was ingested by Snowflake.

 NOTE: During pipe creation, instantiating an iam role is not instantaneous, to get around the pipe looking for a role that is still being created, we use a local-exec statement and shell command to wait 10 seconds.

 ### Checking a pipes status
  Once deployed, check a pipe's status using:

          SELECT system$pipe_status('database_name.schema_name.pipe_name');

### Pipe module design
To make use of the modular pattens, the resources created by them are separated into their own directory and remote state file to isolate them from one another. This allows actions like `terraform destroy` to remove the group of resources that support a pipe or stage without affecting other pipes. This one-to-one relationship increases reliability and depending on s3 key access, enhances security to a more granular level.

 ### Pipe dependencies
 The recommended way to deploy a pipe is with the module; that said, it is useful to understand what is going on under-the-hood. The following summaries the steps to create the individual supporting resources:
 - Create a database and schema where an external stage can live.
 - If it does not already exist, create the landing table where data will be ingested into.
 - Next we require an account integration to connect to an external AWS account.
 - Once this has been established we can create the external stage, which is dependent on the account integration and s3 bucket.
 - Now Snowflake has set its external ID we can create the IAM role which will allow Snowflake to read from the S3 bucket.
 - Finally, create the Snowpipe. The pipe creates it's own AWS SQS service behind the scenes which Snowflake manages, this is configured to receive event notifications from your s3 bucket when files land and automatically copy them to the landing table.

 Note: If you modify or recreate the account integration, a new `snowflake_external_id` will be generated; you will need to destroy the existing resources that depend on the integration and redeploy them to re-establish the link.
