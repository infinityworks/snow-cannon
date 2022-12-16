import logging
from json import loads, dumps
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class CloudWatchObservability:
    def __init__(self, logs_client, cloudwatch_client, event):
        self.logs_client = logs_client
        self.cloudwatch_client = cloudwatch_client
        self.event = event

    def create_parameters_from_sns_topic(self):
        cloudwatch_parameters = {
            "logGroupName": f"{self.event.get('TopicArn').split(':')[-1]}",
        }
        return cloudwatch_parameters

    def create_error_map_from_event(self):
        timestamp = self.event.get("Timestamp")
        epoch_timestamp_in_milliseconds = (
            convert_timestamp_to_epoch_time_in_milliseconds(timestamp)
        )
        message = loads(self.event.get("Message"))
        error_type = message.get("messageType")
        topic = self.event.get("TopicArn")
        pipe_name = message.get("pipeName")
        table_name = message.get("tableName")
        source = message.get("stageLocation")
        message = message.get("messages")
        snowpipe_error_map = {
            "error_type": error_type,
            "topic": topic,
            "timestamp": epoch_timestamp_in_milliseconds,
            "facts": {
                "pipe_name": pipe_name,
                "table_name": table_name,
                "source": source,
                "message": message,
            },
        }
        return snowpipe_error_map

    def create_error_log_group(self, parameters):
        try:
            return self.logs_client.create_log_group(**parameters)
        except Exception as exception:
            error_code = exception.response.get("Error").get("Code")
            if error_code != "ResourceAlreadyExistsException":
                raise exception

    def create_error_log_stream(self, parameters):
        try:
            return self.logs_client.create_log_stream(**parameters)
        except Exception as exception:
            error_code = exception.response.get("Error").get("Code")
            if error_code != "ResourceAlreadyExistsException":
                raise exception
            return {"log_stream_exists": True}

    def if_exists_get_log_stream_sequence_token(self, parameters):
        modified_parameter_keys = {k: v for k, v in parameters.items()}
        modified_parameter_keys["logStreamNamePrefix"] = modified_parameter_keys.pop(
            "logStreamName"
        )
        stream_description = self.logs_client.describe_log_streams(
            **modified_parameter_keys
        )
        if stream_description.get("logStreams"):
            return stream_description.get("logStreams")[0].get("uploadSequenceToken")

    def put_error_log_event(self, parameters, snowpipe_error_map):
        parameters.update(
            {
                "logEvents": [
                    {
                        "timestamp": snowpipe_error_map.get("timestamp"),
                        "message": dumps(snowpipe_error_map),
                    }
                ]
            }
        )

        try:
            put_logs_response = self.logs_client.put_log_events(**parameters)
            return put_logs_response
        except Exception as exception:
            error_code = exception.response.get("Error").get("Code")
            if error_code != "DataAlreadyAcceptedException":
                raise exception

    def put_metric(self, parameters, snowpipe_error_map):
        pipe_name_in_error = snowpipe_error_map.get("facts").get("pipe_name")
        response = self.cloudwatch_client.put_metric_data(
            Namespace="snowpipe-alerts",
            MetricData=[
                {
                    "MetricName": "snowpipe-ingestion-error-channel",
                    "Dimensions": [
                        {
                            "Name": "logGroupName",
                            "Value": parameters.get("logGroupName"),
                        },
                        {
                            "Name": "pipe-name",
                            "Value": pipe_name_in_error,
                        },
                        {
                            "Name": "error-type/logStreamName",
                            "Value": parameters.get("logStreamName"),
                        },
                    ],
                    "Unit": "Count",
                    "StorageResolution": 60,
                    "Value": 1,
                },
            ],
        )
        return response
        # logger.info(f"Number of new objects pushed to CloudWatch\n")


def convert_timestamp_to_epoch_time_in_milliseconds(timestamp):
    epoch_timestamp = datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ").timestamp()
    epoch_timestamp_in_milliseconds = int(epoch_timestamp * 1000)
    return epoch_timestamp_in_milliseconds
