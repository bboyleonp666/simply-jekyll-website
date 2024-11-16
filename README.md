# Simple website deployment
This repository supports website deployment with gmail API that can send `noreply` emails to your desired account.  

## Requirements
1. Clone this repository with `git clone --recursive https://github.com/bboyleonp666/simply-jekyll-website.git`
2. Install `docker` and `docker-compose`
3. Create a gmail robot account and obtain the credential file, put it in `service/gmail_api/credentail.json`, then run initialization script.

## Configuration
The configuration file is `.env`. For quick deployment, simply modify the configuration value accroding to your needs.  
- local deployment: use default value.
- custom domain name: replace `DOMAIN` value with your domain.

## Quick Start
1. `docker compose build`
2. `docker compose up`

## Bonus
If you would like to have a valid certificate, you may want to check [Let's Encrypt](https://letsencrypt.org/getting-started/).  
Or follow the steps below
1. `$pip install certbot`
2. `certbot certonly --email <yourmail> -d <yourdomain> --agree-tos --manual`
3. replace the path to the certificate in `nginx/generated/site.conf` accordingly
