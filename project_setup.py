import glob
import re


def replace_project_name(current_name="snow-cannon", dirs_to_glob="./**/*.tf"):
    project_name = input(
        "Enter your project name; this is used in naming resources like the AWS S3 buckets for remote state and data lake:\n"
    )
    project_name_replace_specials = re.sub(r"[^a-zA-Z0-9]+", "-", project_name)

    for filepath in glob.iglob(dirs_to_glob, recursive=True):
        with open(filepath) as file:
            file_contents = file.read()
        file_contents = file_contents.replace(
            current_name, project_name_replace_specials
        )
        with open(filepath, "w") as file:
            file.write(file_contents)


if __name__ == "__main__":
    replace_project_name(current_name="snow-cannon")
