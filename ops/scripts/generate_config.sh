#!/usr/bin/env bash

# bail out upon error
set -e

# bail out if an unset variable is used
set -u

# display the lines of this script as they are executed for debugging
# set -x

# export all variables that need to be substituted in templates
set -a
# Setting up in-container application source variable (APP_SOURCE).
# It's the counterpart of the host variable APPLICATION
#APP_SOURCE=/var/www
APP_SOURCE=$PWD

# Warning to dissuade from modify the generated composer.json file
COMPOSER_WARNING="!! Auto-generated file, edit ops/php-conf/composer.json.dist instead"

# read env variables in same directory, from a file called .env.
# They are shared by both this script and Docker compose files.
#cd $APP_SOURCE
echo "Current working directory: $PWD"

if [ -f  ./.env ];then
    echo "An .env file is present, sourcing it"
    source "./.env"
fi

# Print directory of this script. We will need it to find nginx config
THIS_SCRIPT_DIR=`dirname "$BASH_SOURCE"`
echo "Running ${THIS_SCRIPT_DIR}/generate_config.sh for environment: $GIGABLOG_ENV"


# Fetch and set environment variables from GitLab
# Only necessary on DEV, as on CI (STG and PROD), the variables are exposed to build environment
if ! [ -f  ./.secrets ];then
    echo "Retrieving variables from ${PROJECT_VARIABLES_URL}"
    curl -s --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "${PROJECT_VARIABLES_URL}?per_page=100" | jq -r '.[] | select(.key != "ANALYTICS_PRIVATE_KEY") | select(.key != "TLSAUTH_CERT") | select(.key != "TLSAUTH_KEY") | select(.key != "TLSAUTH_CA") | select(.key != "staging_tlsauth_ca") | select(.key != "staging_tlsauth_key") | select(.key != "staging_tlsauth_cert") | select(.key != "production_tlsauth_ca") | select(.key != "production_tlsauth_cert") | select(.key != "production_tlsauth_key") |.key + "=" + .value' > .project_var
    cat .project_var > .secrets && rm .project_var
fi
echo "Sourcing secrets"
source "./.secrets"

## If we are on staging environment override variable name with STAGING_* counterpart
#if [ $GIGADB_ENV == "staging" ];then
#    GIGADB_HOST=$STAGING_GIGADB_HOST
#    GIGADB_USER=$STAGING_GIGADB_USER
#    GIGADB_PASSWORD=$STAGING_GIGADB_PASSWORD
#    GIGADB_DB=$STAGING_GIGADB_DB
#    HOME_URL=$STAGING_HOME_URL
#    PUBLIC_HTTP_PORT=$STAGING_PUBLIC_HTTP_PORT
#    PUBLIC_HTTPS_PORT=$STAGING_PUBLIC_HTTPS_PORT
#fi
## restore default settings for variables
#set +a
#
#echo "* ---------------------------------------------- *"

# Create config files for WP
SOURCE=${APP_SOURCE}/ops/configuration/trellis/wordpress_sites.yml.dist
TARGET=${APP_SOURCE}/trellis/group_vars/development/wordpress_sites.yml
VARS='$GIGABLOG_LOCAL_ADMIN_EMAIL:$GIGABLOG_LOCAL_URL'
envsubst $VARS < $SOURCE > $TARGET

SOURCE=${APP_SOURCE}/ops/configuration/trellis/vault.yml.dist
TARGET=${APP_SOURCE}/trellis/group_vars/development/vault.yml
VARS='$GIGABLOG_LOCAL_DB_PASSWORD:$GIGABLOG_LOCAL_URL:$GIGABLOG_LOCAL_ADMIN_PASSWORD'
envsubst $VARS < $SOURCE > $TARGET

#if [ $GIGADB_ENV != "CI" ];then
#    cp ops/configuration/nginx-conf/le.${GIGADB_ENV}.ini /etc/letsencrypt/cli.ini
#fi

echo "done."
exit 0
