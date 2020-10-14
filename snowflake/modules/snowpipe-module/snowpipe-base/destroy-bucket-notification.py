import boto3
import argparse


class DestroySnowPipeBucketNotification:

    s3 = boto3.resource("s3")

    def __init__(self, bucket, s3_key):
        self.bucket = bucket
        self.s3_key = s3_key
        self.bucket_notifications = self.s3.BucketNotification(bucket)

    def delete_bucket_notification(self):
        self.notification_id = "-".join(
            [self.bucket, self.s3_key, "snowpipe-notification"]
        )
        queue_configurations = self.bucket_notifications.queue_configurations
        if queue_configurations:
            configs = [
                queue_config
                for queue_config in queue_configurations
                if queue_config["Id"] != self.notification_id
            ]
            self.bucket_notifications.put(
                NotificationConfiguration={"QueueConfigurations": configs}
            )
        print([queue_config["Id"] for queue_config in configs])


def set_input_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--bucket", "-b", help="Target s3 bucket to list notifications from"
    )
    parser.add_argument(
        "--s3_key",
        "-k",
        help="s3 key name which you wish to remove a notification from",
    )
    cli_args = parser.parse_args()
    return cli_args


if __name__ == "__main__":
    cli_args = set_input_arguments()
    bucket_notifications = DestroySnowPipeBucketNotification(
        cli_args.bucket, cli_args.s3_key
    )
    bucket_notifications.delete_bucket_notification()
