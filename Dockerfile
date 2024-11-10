FROM ubuntu:22.04 AS base
LABEL maintainer="bboyleonp666 <bboyleonp@gmail.com>"

RUN apt update && \
    apt install -y build-essential ruby ruby-bundler ruby-dev && \
    apt install -y nginx openssl systemctl git vim curl && \
    openssl req -x509 \
        -nodes \
        -days 3650 \
        -newkey rsa:4096 \
        -subj "/C=TW/ST=TW/L=/O=/OU=/CN=localhost" \
        -keyout /etc/ssl/private/selfsigned.key \
        -out /etc/ssl/certs/selfsigned.crt 2>/dev/null


##### ----- site-builder ----- #####
FROM base AS site-builder

COPY ./systemd/ /root/systemd/

RUN chown -R root:root /root/systemd/ && \
    chmod +x /root/systemd/scripts/deploy-web.sh && \
    ln -s /root/systemd/scripts/deploy-web.sh /usr/local/bin/deploy-web && \
    ln -s /root/systemd/services/web-deployd.service /usr/lib/systemd/system/web-deployd.service


##### ----- nginx ----- #####
FROM base AS nginx

RUN ln -s /root/generated/site.conf /etc/nginx/sites-enabled/site.conf


##### ----- gmail-api ----- #####
FROM azul/zulu-openjdk:21 AS gmail-api-build

ARG PORT=8964 LOG_LEVEL=INFO

COPY ./service/ /root/service/

RUN sed -i "s/^server\.port=.*/server.port=${PORT}/" \
        /root/service/src/main/resources/application.properties && \
    sed -i "s/^logging\.level\.com\.city4crew\.service=.*/logging.level.com.city4crew.service=${LOG_LEVEL}/g" \
        /root/service/src/main/resources/application.properties && \
    cd /root/service && \
    ./gradlew build --no-daemon

FROM azul/zulu-openjdk:21 AS gmail-api

COPY --from=gmail-api-build /root/service/build/libs/service-0.0.1-SNAPSHOT.jar /root/gmail-api-agent.jar
COPY ./service/gmail_api/requirements.txt /tmp/requirements.txt

RUN apt update && \
    apt install -y python3 python3-pip && \
    pip install -r /tmp/requirements.txt

