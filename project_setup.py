import glob
import re


def replace_project_name(
    current_project_name="snow-cannon", dirs_to_glob=["./**/*.tf", "./**/*.sh"]
):

    if not isinstance(dirs_to_glob, list):
        dirs = [dirs_to_glob]
    else:
        dirs = dirs_to_glob

    files_globbed = []
    for files in dirs:
        files_globbed.extend(glob.iglob(files, recursive=True))

    globbed_files = set(files_globbed)
    ignore_files = set(glob.iglob("./tests/**/*.tf", recursive=True))
    files_to_modify = globbed_files - ignore_files

    project_name = input(
        "Enter your project name; this is used in naming resources like the AWS S3 buckets for remote state and data lake:\n"
    )
    project_name_replace_specials = re.sub(r"[^a-zA-Z0-9]+", "-", project_name)

    print(f"Project name: {project_name_replace_specials}")

    for filepath in files_to_modify:
        with open(filepath) as file:
            file_contents = file.read()
        file_contents = file_contents.replace(
            current_project_name, project_name_replace_specials
        )
        with open(filepath, "w") as file:
            file.write(file_contents)


if __name__ == "__main__":
    replace_project_name(current_project_name="snow-cannon")
