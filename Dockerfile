ARG GUNBOTVERSION="latest"
ARG GITHUBOWNER="GuntharDeNiro"
ARG GITHUBREPO="BTCT"

FROM alpine:latest AS gunbot-builder
ARG GUNBOTVERSION
ARG GITHUBOWNER
ARG GITHUBREPO

WORKDIR /tmp

RUN apk update \
  && apk add --no-cache wget jq unzip openssl \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q -nv -O gunbot.zip $(wget -q -nv -O- https://api.github.com/repos/${GITHUBOWNER}/${GITHUBREPO}/releases/${GUNBOTVERSION} 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("gunthy_linux")) | .browser_download_url') \
  && unzip -d . gunbot.zip \
  && mv gunthy_linux gunbot \
  && printf "[req]\n" > ssl.config \
  && printf "distinguished_name = req_distinguished_name\n" >> ssl.config \
  && printf "prompt = no\n" >> ssl.config \
  && printf "[req_distinguished_name]\n" >> ssl.config \
  && printf "commonName = localhost\n" >> ssl.config \
  && openssl req -config ssl.config -newkey rsa:2048 -nodes -keyout gunbot/localhost.key -x509 -days 365 -out gunbot/localhost.crt \
  && contents="$(jq '.GUI.https = true' gunbot/config.js)" \
  && echo "${contents}" > gunbot/config.js \
  && printf "#!/bin/sh\n" > gunbot/startup.sh \
  && printf "chronyd -d || :\n" >> gunbot/startup.sh \
  && printf "/opt/gunbot/gunthy-linux\n" >> gunbot/startup.sh

FROM alpine:latest
ARG DISTRO
ARG VERSION
ARG GUNBOTVERSION
ENV GUNBOTPORT=5000

LABEL \
  maintainer="computeronix" \
  website="https://aka.wf/ai6" \
  description="docker file alpine, containerized gunbot - ${GUNBOTVERSION}"

COPY --from=gunbot-builder /tmp/gunbot /opt/gunbot

WORKDIR /opt/gunbot

RUN apk update \
  && apk add --no-cache chrony libc6-compat gcompat libstdc++ \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x /opt/gunbot/startup.sh

EXPOSE ${GUNBOTPORT}
CMD ["/opt/gunbot/startup.sh"]
