from boto3 import client

# from aws_lambda_powertools import Tracer, Logger
from json import dumps, loads
from cloudwatch_client import CloudWatchObservability
import logging

logging.basicConfig(level=logging.INFO, format="%(message)s")
log = logging.getLogger()
log.setLevel(logging.INFO)

# tracer = Tracer()
# @tracer.capture_lambda_handler
# @logger.inject_lambda_context


def handler(event: None, context: None):
    log.info(f"event: {dumps(event, indent=4)}")

    snowpipe_event = loads(event.get("Records")[0].get("body"))
    log.info(f"snowpipe_event: {dumps(snowpipe_event, indent=4)}")

    logs_client = client("logs")
    cloudwatch_client = client("cloudwatch")
    cloudwatch = CloudWatchObservability(logs_client, cloudwatch_client, snowpipe_event)

    parameters = cloudwatch.create_parameters_from_sns_topic()
    log.info(f"parameters: {parameters}")

    response = cloudwatch.create_error_log_group(parameters)
    log.info(f"create_error_log_group: {response}")

    snowpipe_error_map = cloudwatch.create_error_map_from_event()
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
        snowpipe_error_map=snowpipe_error_map,
    )
    log.info(f"put_error_log_event: {response}")

    response = cloudwatch.put_metric(parameters, snowpipe_error_map)
    log.info(f"put_metric: {response}")
    # # tracer.put_annotation(key="PublishNotification", value="SUCCESS")

    return


if __name__ == "__main__":
    from pathlib import Path
    from json import load

    event_file = Path("./tests/event.json")
    with open(event_file) as file:
        event = load(file)
    handler(event, context=None)
