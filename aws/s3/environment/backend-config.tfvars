<<<<<<< HEAD:aws/s3/environment/backend-config.tfvars
bucket         = "snow-cannon-remote-state"
key            = "persistence/s3/terraform.tfstate"
=======
bucket         = "snow-cannon-remote-state-dev"
key            = "snowflake/stages/terraform.tfstate"
>>>>>>> - Create stages module:snowflake/infra/stages/environment/dev/backend-config.tfvars
region         = "eu-west-2"
dynamodb_table = "snow-cannon-lock-table"
encrypt        = true
