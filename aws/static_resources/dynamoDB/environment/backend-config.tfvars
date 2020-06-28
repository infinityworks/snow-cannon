bucket         = "sub-zero-remote-state"
key            = "persistence/dynamodb/terraform.tfstate"
region         = "eu-west-2"
dynamodb_table = "sub-zero-lock-table"
encrypt        = true
