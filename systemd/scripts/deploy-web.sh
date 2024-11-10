#!/bin/bash

pr_debug() {
    source /root/systemd/logger.conf
    if [ "$LOG_LEVEL" == "DEBUG" ]; then
        echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][DEBUG] $1"
    fi
}

build_site() {
    cd /app/agency-jekyll-theme
    pr_debug "Update website ..."
    # bundle install
    bundle exec jekyll build > /dev/null
}

change_domain() {
    local match_conf='^contactus_api: .*'
    local new_url="contactus_api: \"https://${DOMAIN}/contactus\""
    pr_debug "Change API /contactus to '$new_url'"
    sed -i "s|$match_conf|$new_url|" /app/agency-jekyll-theme/_config.yml
}

main() {
    change_domain
    while true; do
        build_site
        sleep 10
    done
}

main
