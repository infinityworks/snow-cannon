import pytest
from project_setup import replace_project_name


def test_replace_project_name(monkeypatch):
    monkeypatch.setattr("builtins.input", lambda _: "my-project")

    tf_file = "tests/fixtures/backend.tf"
    test_tf_file = "tests/fixtures/backend_test.tf"

    replace_project_name(
        current_project_name="snow-cannon", dirs_to_glob="tests/fixtures/backend.tf"
    )

    with open(tf_file) as file:
        modified_tf_file_contents = file.read()

    with open(test_tf_file) as file:
        test_tf_file_contents = file.read()

    assert modified_tf_file_contents == test_tf_file_contents


def test_revert_project_name(monkeypatch):
    monkeypatch.setattr("builtins.input", lambda _: "snow-cannon")

    tf_file = "tests/fixtures/backend.tf"
    test_tf_file = "tests/fixtures/backend_snow.tf"

    replace_project_name(
        current_project_name="my-project", dirs_to_glob="tests/fixtures/backend.tf"
    )

    with open(tf_file) as file:
        modified_tf_file_contents = file.read()

    with open(test_tf_file) as file:
        test_tf_file_contents = file.read()

    assert modified_tf_file_contents == test_tf_file_contents
