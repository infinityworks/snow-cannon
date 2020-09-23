import boto3
import argparse


class CreateSnowPipeBucketNotification:

    s3 = boto3.resource("s3")

    def __init__(self, bucket, s3_key, queue_arn, prefix, suffix):
        self.bucket = bucket
        self.s3_key = s3_key
        self.queue_arn = queue_arn
        self.prefix = prefix
        self.suffix = suffix
        self.bucket_notifications = self.s3.BucketNotification(bucket)

    def create_bucket_notification(self):
        self.notification_id = "-".join(
            [self.bucket, self.s3_key, "snowpipe-notification"]
        )
        self.notification = {
            "Id": self.notification_id,
            "QueueArn": self.queue_arn,
            "Events": ["s3:ObjectCreated:*"],
            "Filter": {
                "Key": {
                    "FilterRules": [
                        {"Name": "Prefix", "Value": self.prefix},
                        {"Name": "Suffix", "Value": self.suffix},
                    ]
                }
            },
        }
        return self.notification

    def add_or_update_bucket_notification(self):
        queue_configurations = self.bucket_notifications.queue_configurations
        if queue_configurations:
            configs = [
                queue_config
                for queue_config in queue_configurations
                if queue_config["Id"] != self.notification_id
            ]
            configs.append(self.notification)
        else:
            configs = [self.notification]
        self.bucket_notifications.put(
            NotificationConfiguration={"QueueConfigurations": configs}
        )
        print([queue_config["Id"] for queue_config in configs])


def set_input_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--bucket", "-b", help="Target s3 bucket to set a notification on"
    )
    parser.add_argument(
        "--s3_key", "-k", help="s3 key name which you wish to set the notification on"
    )
    parser.add_argument(
        "--queue_arn", "-q", help="Snowpipe queue arn provided by Snowflake"
    )
    parser.add_argument(
        "--prefix", "-p", help="File filter prefix", nargs="?", const=""
    )
    parser.add_argument(
        "--suffix", "-s", help="File filter suffix", nargs="?", const=""
    )
    cli_args = parser.parse_args()
    return cli_args


if __name__ == "__main__":
    cli_args = set_input_arguments()
    bucket_notifications = CreateSnowPipeBucketNotification(
        cli_args.bucket,
        cli_args.s3_key,
        cli_args.queue_arn,
        cli_args.prefix,
        cli_args.suffix,
    )
    bucket_notifications.create_bucket_notification()
    bucket_notifications.add_or_update_bucket_notification()
