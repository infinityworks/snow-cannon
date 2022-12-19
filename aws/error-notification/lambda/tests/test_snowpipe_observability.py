from conftest import read_file
from pathlib import Path
import pytest
from snowpipe_event_formatting import SnowPipeEventHandler


@pytest.fixture()
def event():
    FIXTURES = Path(__file__).parent / "fixtures"
    test_event_path = FIXTURES / "event.json"
    test_event = read_file(test_event_path)
    return test_event


class TestSnowPipeObservabilityFormatting:
    @pytest.fixture(autouse=True)
    def _snowpipe_observability(self, event):
        self._event_handler = SnowPipeEventHandler(event)

    def test_create_error_map_from_event(self):
        error_map = self._event_handler.create_error_map_from_event()
        assert error_map == {
            "error_type": "INGEST_FAILED_FILE",
            "topic": "arn:aws:sns:eu-west-2:054663422011:snowpipe-error-notification-channel",
            "timestamp": 1671204159428,
            "facts": {
                "pipe_name": "ANALYTICS.PUBLIC.CUSTOMERS_DATA_PIPE",
                "table_name": "ANALYTICS.PUBLIC.CUSTOMERS",
                "source": "s3://snow-cannon-data-lake-dev/customers/",
                "message": [
                    {
                        "fileName": "test19.csv",
                        "firstError": "Numeric value 'field,type' is not recognized",
                    }
                ],
            },
        }

    def test_create_parameters_from_sns_topic(self):
        parameters = self._event_handler.create_parameters_from_sns_topic()
        assert parameters == {"logGroupName": "snowpipe-error-notification-channel"}

    def test_convert_timestamp_to_epoch_time_in_milliseconds(self):
        timestamp = "2022-12-16T15:22:39.428Z"
        converted_time = (
            self._event_handler.convert_timestamp_to_epoch_time_in_milliseconds(
                timestamp
            )
        )
        assert converted_time == 1671204159428
