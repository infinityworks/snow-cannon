# Snowpipe Error Logging

This directory contains the resources to create an observability error channel (logs and metrics) from failed file delivery from AWS S3 to Snowflake tables.

The observability included here logs the failure of file delivery to a log group which name is derived from the SNS topic (sns.tf) subscribed to Snowflake Notification Integration (snowflake-notification-integration.tf). The log is generated from the SNS message published to a queue (sqs.tf) where a lambda is triggered and write the failure type to the log group and a metric. Each metric is categorised into an individual log stream based upon the delivery failure type.

To run a local integration test, deploy the following:

    module "test_pipe_to_fail" {
    source            = "../../snowflake/modules/snowpipe-module/"
    s3_bucket_name    = "[your-test-bucket]"
    s3_path           = "[s3-path]"
    database          = "[test-db]"
    schema            = "[test-schema]"
    error_integration = "SNOWPIPE_ERROR_CHANNEL"
    file_format       = "CSV"
    field_delimiter   = "\t"
    record_delimiter  = "\n"
    filter_suffix     = ".csv"
    }

This will use the `table-definition.csv` to create the landing table in this directory and you can push `test.csv` which has a different table schema and will force a pipe delivery error.

To upload the test file from the CLI:

    aws s3 cp test.csv s3://[your-test-bucket]/[s3-path]/test.csv
