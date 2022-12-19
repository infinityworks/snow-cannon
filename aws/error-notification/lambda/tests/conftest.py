import sys
from pathlib import Path
from json import load

project_path = str(Path(__file__).parent / "..")
sys.path.append(project_path)


def read_file(path, mode="r"):
    with open(path, mode) as file:
        return load(file)
