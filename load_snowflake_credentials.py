import os
import argparse
import configparser


def print_env_vars_for_terminal_eval_to_export(profile: str, application: str):
    credentials = get_snowflake_credentials(profile=profile)
    if application == "snowsql":
        print_snowsql_auth_env_vars(credentials=credentials)
    elif application == "terraform":
        print_terraform_auth_env_vars(credentials=credentials)
    elif application == "all":
        print_snowsql_auth_env_vars(credentials=credentials)
        print_terraform_auth_env_vars(credentials=credentials)
    else:
        raise ValueError(
            "Optional argument 'application' must be either 'terraform', 'snowsql' or 'all'"
        )
    print('export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"')


def get_snowflake_credentials(profile: str) -> configparser.SectionProxy:
    home_dir = os.environ.get("HOME")
    snowsql_credentials = f"{home_dir}/.snowsql/config"

    config = configparser.ConfigParser()
    config.read(snowsql_credentials)

    if profile in config.sections():
        credentials = config[profile]
        return credentials
    else:
        raise KeyError(
            f"Profile '{profile}' does not exist in snowsql config; check your profiles or default to 'connections'"
        )


def set_input_arguments() -> (str, str):
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-p",
        "--profile",
        default="connections",
        help="The target snowflake profile who's credentials will be used",
    )
    parser.add_argument(
        "-a",
        "--application",
        default="all",
        help="Determines which env var credentials set is to be exported for snowsql, terraform or all",
    )
    cli_args = parser.parse_args()
    profile = cli_args.profile
    application = cli_args.application
    return profile, application


def print_terraform_auth_env_vars(credentials):
    if "username" in credentials:
        print(f"export SNOWFLAKE_USER={credentials['username']}")
    if "password" in credentials:
        print(f"export SNOWFLAKE_PASSWORD={credentials['password']}")


def print_snowsql_auth_env_vars(credentials):
    if "username" in credentials:
        print(f"export SNOWSQL_USER={credentials['username']}")
    if "password" in credentials:
        print(f"export SNOWSQL_PWD={credentials['password']}")
    if "accountname" in credentials:
        print(f"export SNOWSQL_ACCOUNT={credentials['accountname']}")
    if "region" in credentials:
        print(f"export SNOWSQL_REGION={credentials['region']}")
    if "database" in credentials:
        print(f"export SNOWSQL_DATABASE={credentials['database']}")
    if "schema" in credentials:
        print(f"export SNOWSQL_SCHEMA={credentials['schema']}")
    if "role" in credentials:
        print(f"export SNOWSQL_ROLE={credentials['role']}")
    if "warehouse" in credentials:
        print(f"export SNOWSQL_WAREHOUSE={credentials['warehouse']}")


if __name__ == "__main__":
    profile, application = set_input_arguments()
    print_env_vars_for_terminal_eval_to_export(profile, application)
