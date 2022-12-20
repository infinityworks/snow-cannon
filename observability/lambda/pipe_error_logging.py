from boto3 import client
from json import dumps, loads
from cloudwatch_client import CloudWatchObservability
from snowpipe_event_formatting import SnowPipeEventHandler
import logging

# from aws_lambda_powertools import Tracer, Logger

logging.basicConfig(level=logging.INFO, format="%(message)s")
log = logging.getLogger()
log.setLevel(logging.INFO)

# tracer = Tracer()
# @tracer.capture_lambda_handler
# @logger.inject_lambda_context


def handler(event: None, context: None):
    log.info(f"event: {dumps(event, indent=4)}")

    logs_client = client("logs")
    cloudwatch_client = client("cloudwatch")
    cloudwatch = CloudWatchObservability(logs_client, cloudwatch_client)

    snowpipe_event_handler = SnowPipeEventHandler(event)
    snowpipe_error_message = snowpipe_event_handler.message()
    log.info(f"snowpipe_event: {dumps(snowpipe_error_message, indent=4)}")

    parameters = snowpipe_event_handler.create_parameters_from_sns_topic()
    log.info(f"parameters: {parameters}")

    response = cloudwatch.create_error_log_group(parameters)
    log.info(f"create_error_log_group: {response}")

    snowpipe_error_map = snowpipe_event_handler.create_error_map_from_event()

    log.info(f"snowpipe_error_map: {snowpipe_error_map}")

    log_stream_name = snowpipe_error_map.get("error_type")
    parameters.update({"logStreamName": log_stream_name})
    log.info(f"parameters: {parameters}")

    sequence_token = cloudwatch.if_exists_get_log_stream_sequence_token(parameters)
    if sequence_token:
        parameters.update({"sequenceToken": sequence_token})
    if not sequence_token:
        response = cloudwatch.create_error_log_stream(parameters)
        log.info(f"create_error_log_stream: {response}")

    response = cloudwatch.put_error_log_event(
        parameters=parameters,
        resource_error_map=snowpipe_error_map,
    )
    log.info(f"put_error_log_event: {response}")
    pipe_attributes = {
        "name": snowpipe_error_map.get("facts").get("pipe_name"),
        "resource_type": "pipe",
    }

    response = cloudwatch.put_metric(
        parameters=parameters,
        resource_in_error=pipe_attributes,
        namespace="snowpipe-alerts",
        metric_name="snowpipe-ingestion-error-channel",
    )
    log.info(f"put_metric: {response}")

    return


if __name__ == "__main__":
    from pathlib import Path
    from json import load

    event_file = Path("./tests/fixtures/event.json")
    with open(event_file) as file:
        event = load(file)
    handler(event, context=None)
