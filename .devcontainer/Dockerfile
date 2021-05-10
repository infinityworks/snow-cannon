#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Pick any base image, but if you select node, skip installing node. 😊
FROM debian:10

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Terraform and tflint versions
ARG TERRAFORM_VERSION=0.13.5
ARG TFLINT_VERSION=0.15.4

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # install git iproute2, required tools installed
    && apt-get install -y \
    bash-completion \
    git \
    openssh-client \
    less \
    curl \
    fd-find \
    ripgrep \
    procps \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    python3-pip \
    lsb-release 2>&1 \
    #
    # [Optional] For local testing instead of cloud shell
    # Install Docker CE CLI.
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    #
    # Install the AWS CLI tools
    #
    && mkdir -p /tmp/aws \
    && cd /tmp/aws \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && pip3 install git-remote-codecommit \
    && pip3 install boto3 \
    # Support `cidr.py`
    && pip3 install tabulate \
    # Session manager plugin for SSHing etc
    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" \
    && dpkg -i /tmp/session-manager-plugin.deb \
    #
    # Install Terraform, tflint, and graphviz
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin \
    && curl -sSL -o /tmp/docker-downloads/tflint.zip https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
    && unzip /tmp/docker-downloads/tflint.zip \
    && mv tflint /usr/local/bin \
    && cd ~ \
    && rm -rf /tmp/docker-downloads \
    && apt-get install -y graphviz \
    && apt-get install -y jq \
    # And Adrian's fork of `terraform-lsp`
    && curl -sL https://github.com/awilkins/terraform-lsp/releases/download/v0.0.11-beta1-atw/terraform-lsp_0.11-beta1-atw_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ \
    # Wallix awless (easier AWS tool)
    && curl -L https://github.com/wallix/awless/releases/download/v0.1.11/awless-linux-amd64.tar.gz  | tar -xz -C /usr/local/bin/ \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Alias for fd
    && echo "alias fd=fdfind" >> /home/${USERNAME}/.bashrc \
    #
    # Starship prompt
    #
    && curl -fsSL https://starship.rs/install.sh | bash -s -- --yes \
    && echo 'eval "$(starship init bash)"' >> /home/$USERNAME/.bashrc \
    && echo 'source <(awless completion bash)' >> /home/$USERNAME/.bashrc \
    #
    # Ondir for environment switching
    && apt-get install -y ondir \
    && echo 'source /usr/share/ondir/integration/bash' >> /home/$USERNAME/.bashrc \
    #
    # git-secrets to help prevent committing secrets to git
    && mkdir -p /tmp/secrets && cd /tmp/secrets \
    && git clone https://github.com/awslabs/git-secrets.git \
    && cd git-secrets \
    && make install \
    #
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


COPY --chown=${USER_UID}:${USER_GID} .terraformrc .ondirrc /home/${USERNAME}/

RUN git secrets --register-aws --global \
    && git secrets --install ~/.git-templates/git-secrets \
    && git config --global init.templateDir ~/.git-templates/git-secrets

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
# Command line use of git needs an editor
ENV EDITOR=code

RUN curl -sSf https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.9-linux_x86_64.bash -o snowsql.bash && \
    touch $HOME/.profile && \
    SNOWSQL_DEST=/bin SNOWSQL_LOGIN_SHELL=$HOME/.profile bash snowsql.bash && rm -f snowsql.bash

ENV TF_PLUGIN_CACHE_DIR=/home/vscode/.terraform.d/plugin-cache
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip3 install aws-google-auth
ADD ./requirements.txt /usr/local/requirements.txt
RUN pip3 install --requirement /usr/local/requirements.txt
