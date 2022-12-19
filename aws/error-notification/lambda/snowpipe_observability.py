import logging
from json import loads
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class SnowPipeObservabilityFormatting:
    def __init__(self, event):
        self.event = event

    def create_error_map_from_event(self):
        timestamp = self.event.get("Timestamp")
        print(timestamp)
        epoch_timestamp_in_milliseconds = (
            self.convert_timestamp_to_epoch_time_in_milliseconds(timestamp)
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

    def convert_timestamp_to_epoch_time_in_milliseconds(self, timestamp):
        epoch_timestamp = datetime.strptime(
            timestamp, "%Y-%m-%dT%H:%M:%S.%fZ"
        ).timestamp()
        epoch_timestamp_in_milliseconds = int(epoch_timestamp * 1000)
        return epoch_timestamp_in_milliseconds
