set -eu

while read line;
    do echo "export $line";
done < ~/.snowflake/credentials;

echo 'TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"'
