ARG GUNBOTVERSION="latest"
ARG GITHUBOWNER="GuntharDeNiro"
ARG GITHUBREPO="BTCT"
ARG GUNBOTPORT="5000"

FROM alpine:latest AS gunbot-builder
ARG GUNBOTVERSION
ARG GITHUBOWNER
ARG GITHUBREPO

WORKDIR /tmp

RUN apk update \
  && apk add --no-cache wget jq unzip openssl \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q -nv -O gunbot.zip $(wget -q -nv -O- https://api.github.com/repos/${GITHUBOWNER}/${GITHUBREPO}/releases/${GUNBOTVERSION} 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("lin")) | .browser_download_url') \
  && unzip -d . gunbot.zip \
  && mv lin* gunbot \
  && printf "[req]\n" > ssl.config \
  && printf "distinguished_name = req_distinguished_name\n" >> ssl.config \
  && printf "prompt = no\n" >> ssl.config \
  && printf "[req_distinguished_name]\n" >> ssl.config \
  && printf "commonName = localhost\n" >> ssl.config \
  && openssl req -config ssl.config -newkey rsa:2048 -nodes -keyout gunbot/localhost.key -x509 -days 365 -out gunbot/localhost.crt \
  && contents="$(jq '.GUI.https = true' gunbot/config.js)" && \
     echo "${contents}" > gunbot/config.js \
  && mkdir supervisor \
  && printf "[supervisord]\n" > supervisor/service_script.conf \
  && printf "nodaemon=true\n" >> supervisor/service_script.conf \
  && printf "\n" >> supervisor/service_script.conf \
  && printf "[program:chronyd]\n" >> supervisor/service_script.conf \
  && printf "command=chronyd -d\n" >> supervisor/service_script.conf \
  && printf "autostart=true\n" >> supervisor/service_script.conf \
  && printf "autorestart=true\n" >> supervisor/service_script.conf \
  && printf "stderr_logfile=/dev/stdout\n" >> supervisor/service_script.conf \
  && printf "stderr_logfile_maxbytes=0\n" >> supervisor/service_script.conf \
  && printf "stdout_logfile=/dev/stdout\n" >> supervisor/service_script.conf \
  && printf "stdout_logfile_maxbytes=0\n" >> supervisor/service_script.conf \
  && printf "\n" >> supervisor/service_script.conf \
  && printf "[program:gunbot]\n" >> supervisor/service_script.conf \
  && printf "command=/opt/gunbot/gunthy-linux\n" >> supervisor/service_script.conf \
  && printf "autostart=true\n" >> supervisor/service_script.conf \
  && printf "autorestart=true\n" >> supervisor/service_script.conf \
  && printf "directory=/opt/gunbot\n" >> supervisor/service_script.conf \
  && printf "stderr_logfile=/dev/stdout\n" >> supervisor/service_script.conf \
  && printf "stderr_logfile_maxbytes=0\n" >> supervisor/service_script.conf \
  && printf "stdout_logfile=/dev/stdout\n" >> supervisor/service_script.conf \
  && printf "stdout_logfile_maxbytes=0\n" >> supervisor/service_script.conf

FROM alpine:latest
ARG DISTRO
ARG VERSION
ARG GUNBOTVERSION
ARG GUNBOTPORT

LABEL \
  maintainer="computeronix" \
  website="https://aka.wf/ai6" \
  description="docker file alpine, containerized gunbot - ${GUNBOTVERSION}"

RUN apt-get update \
  && apt-get -y install supervisor chrony rsync fontconfig \
  && rm -rf /var/lib/apt/lists/*

COPY --from=gunbot-builder /tmp/gunbot /opt/gunbot
COPY --from=gunbot-builder /tmp/supervisor /src/supervisor

EXPOSE ${GUNBOTPORT}
CMD ["supervisord","-c","/src/supervisor/service_script.conf"]
