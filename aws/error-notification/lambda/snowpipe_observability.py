import logging
from json import loads
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class SnowPipeObservabilityFormatting:
    def __init__(self, event):
        self.event = event

    def message(self):
        return loads(self.event.get("Records")[0].get("body"))

    def create_error_map_from_event(self):
        error_message = self.message()
        timestamp = error_message.get("Timestamp")
        epoch_timestamp_in_milliseconds = (
            self.convert_timestamp_to_epoch_time_in_milliseconds(timestamp)
        )
        topic = error_message.get("TopicArn")
        message = loads(error_message.get("Message"))
        error_type = message.get("messageType")
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

    def convert_timestamp_to_epoch_time_in_milliseconds(self, timestamp):
        epoch_timestamp = datetime.strptime(
            timestamp, "%Y-%m-%dT%H:%M:%S.%fZ"
        ).timestamp()
        epoch_timestamp_in_milliseconds = int(epoch_timestamp * 1000)
        return epoch_timestamp_in_milliseconds
