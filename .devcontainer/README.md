# Infrastructure Workstation

The containerized infrastructure workstation has the following features

- Contains all the required tools to manage infrastructure in your target cloud(s)
- Is easily deployed for consistency
- Permits easy and seamless credential selection and management
- Provides information about selected creds and git information

## VSCode Remote Container

This container is defined in the `.devcontainer` folder in the root of the
`infrastructure` repository.

When used in conjunction with the [Remote Containers](https://code.visualstudio.com/docs/remote/containers) extension for VSCode,
this provisions a local Docker container with an infrastructure workstation
environment.

The setup files can also be used as a reference for potentially useful workstation
tooling for a Windows environment if desired.

### Prereqs

1. Docker
   - Preferably Docker Edge running in WSL2 mode, for efficiency
   - Set up to use Linux containers
1. Visual Studio Code
   - plus [Remote Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
1. `.devcontainer` definition
   - This is based on the MS Azure Terraform container
   - This is located in the root of the `infrastructure` repo in the `Tech-Operations` account at present

### Setup

You must permit Docker to share any folders you want to access in the container.

On Windows enabling this is a manual process in the Docker settings applet.

The minimum is

- Your `~/.aws/` folder
- Your source folder

You may find it easiest to share your whole home folder / user profile.

### Usage

1. Clone the `infrastructure` repository
1. Open it in VSCode
1. Use the command palette (`ctrl-shift-P`) to execute "Remote Containers: Reopen in container"
   - VSCode may automatically offer to do this for you
1. The first time you do this (and when the container definition changes) there
   will be a short (~5m) build process as the container is initialized

### Content

1. Common dev tooling inc git, python, openssh-client etc.
1. [git-remote-codecommit](https://github.com/aws/git-remote-codecommit) extension for Git
   - Most consistent and flexible multi-account CodeCommit credentials management
1. AWS CLI tools (v2)
1. [awless](https://github.com/wallix/awless), a useful supplementary AWS CLI
1. The [ssofresh]() scripts to help manage AWS credentials
   - (needs an update to work in containers, in progress)
1. Azure CLI
1. Docker CLI (for managing extra containers alongside this one)
1. [Terraform](https://www.terraform.io/)
   - Plus support tools
   - Configure which version in the Dockerfile
1. The [Starship](https://starship.rs/) prompt tool, providing information in
   the terminal
1. [ondir](https://github.com/alecthomas/ondir)
   - Plus config designed to switch AWS profiles and environment vars quickly
1. [awslabs/git-secrets](https://github.com/awslabs/git-secrets) to help prevent committing secrets to Git
   - Automatically applied to all Git clones made inside the container

# Authentication

For AWS and Snowflake access you will need to set the following env vars in `devcontainer.json`:

# Env var for aws-google-auth
GOOGLE_IDP_ID
GOOGLE_SP_ID
AWS_DEFAULT_REGION
AWS_PROFILE

# Env var for snowsql and Terraform
ENV SNOWFLAKE_ACCOUNT
ENV SNOWSQL_ACCOUNT
ENV SNOWSQL_REGION
ENV SNOWSQL_ROLE
