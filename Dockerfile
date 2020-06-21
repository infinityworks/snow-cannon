FROM hashicorp/terraform:0.12.20
RUN curl https://raw.githubusercontent.com/AdamDewberry/terraform-provider-snowflake/master/download.sh |bash -s -- -b $HOME/.terraform.d/plugins

COPY . .
