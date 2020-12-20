ACCOUNT=$(eval aws sts get-caller-identity)
AWS_ACCOUNT_ID=$(echo $ACCOUNT | jq -r .Account)

TOKEN=$(eval aws sts assume-role --role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/snow-cannon-ci-deployment-role-dev" --role-session-name AWSCLI-Session --duration-seconds 900)

ACCESS_KEY=$(echo $TOKEN | jq -r .Credentials.AccessKeyId)
SECRET_KEY=$(echo $TOKEN | jq -r .Credentials.SecretAccessKey)
SESSION_TOKEN=$(echo $TOKEN | jq -r .Credentials.SessionToken)

echo "export AWS_ACCESS_KEY_ID=${ACCESS_KEY}"
echo "export AWS_SECRET_ACCESS_KEY=${SECRET_KEY}"
echo "export AWS_SESSION_TOKEN=${SESSION_TOKEN}"
