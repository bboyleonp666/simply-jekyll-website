# Jekyll Website Deployment

## Quick Start
1. `$sh setup.sh setup`: setup necessary configuration
2. update your website: `_config.yml`
3. `$docker compose up`
4. Let's Encrypt: get valid certificate
    1. get valid ssh certificate
    2. update ssl cert and key path in /etc/nginx/sites-enable/site.conf
5. Gmail API Token
    1. setup google workspace for gmail api
    2. download credential file
    3. run init script to generate token
    4. test from the website

## Debugging
`$sh setup.sh --debug`

