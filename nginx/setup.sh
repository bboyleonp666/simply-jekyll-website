#!/bin/bash

# set -x

declare -r GENERATED_DIR="generated"
declare -r CONTAINER_ROOT="/app"

declare -r DOMAIN=${DOMAIN:-localhost}
declare -r GMAIL_API_PATH=${GMAIL_API_PATH:-/contactus}
declare -r GMAIL_API_PORT=${GMAIL_API_PORT:-8964}

declare -r SITE_PATH="$CONTAINER_ROOT/agency-jekyll-theme/_site"

gen_nginx_conf() {
    cat conf/site.conf.template | \
        sed "s|PLACEHOLDER_DOMAIN|$DOMAIN|g" | \
        sed "s|PLACEHOLDER_SITE_PATH|$SITE_PATH|g" | \
        sed "s|PLACEHOLDER_GMAIL_API_PATH|$GMAIL_API_PATH|g" | \
        sed "s|PLACEHOLDER_GMAIL_API_PORT|$GMAIL_API_PORT|g" > $GENERATED_DIR/site.conf
}

gen_conf() {
    gen_nginx_conf
}



main() {
    mkdir -p $GENERATED_DIR
    gen_conf
}

main
