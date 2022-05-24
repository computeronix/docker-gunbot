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
  && printf "#!/bin/sh\n" > gunbot/startup.sh \
  && printf "if [ ! -d /mnt/gunbot ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir /mnt/gunbot\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "if [ ! -d /mnt/gunbot/json ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir /mnt/gunbot/json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/json /opt/gunbot/json\n" >> gunbot/startup.sh \
  && printf "if [ ! -d /mnt/gunbot/logs ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir /mnt/gunbot/logs\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/logs /opt/gunbot/logs\n" >> gunbot/startup.sh \
  && printf "if [ ! -d /mnt/gunbot/backups ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir /mnt/gunbot/backups\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/backups /opt/gunbot/backups\n" >> gunbot/startup.sh \
  && printf "if [ ! -d /mnt/gunbot/customStrategies ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir /mnt/gunbot/customStrategies\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/customStrategies /opt/gunbot/customStrategies\n" >> gunbot/startup.sh \
  && printf "if [ ! -f /mnt/gunbot/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/config.js /mnt/gunbot/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/config.js /opt/gunbot/config.js\n" >> gunbot/startup.sh \
  && printf "if [ ! -f /mnt/gunbot/UTAconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/UTAconfig.json /mnt/gunbot/UTAconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/UTAconfig.json /opt/gunbot/UTAconfig.json\n" >> gunbot/startup.sh \
  && printf "if [ ! -f /mnt/gunbot/autoconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/autoconfig.json /mnt/gunbot/autoconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/autoconfig.json /opt/gunbot/autoconfig.json\n" >> gunbot/startup.sh \
  && printf "if [ ! -f /mnt/gunbot/gunbotgui.db ]; then \n" >> gunbot/startup.sh \
  && printf "	touch /opt/gunbot/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/gunbotgui.db /mnt/gunbot/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/gunbotgui.db /opt/gunbot/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "if [ ! -f /mnt/gunbot/new_gui.sqlite ]; then \n" >> gunbot/startup.sh \
  && printf "	touch /opt/gunbot/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/new_gui.sqlite /mnt/gunbot/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf /mnt/gunbot/new_gui.sqlite /opt/gunbot/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "if [ ! -s /mnt/gunbot/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp /opt/gunbot/config-js-example.txt /mnt/gunbot/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "jq '.GUI.https = true' /opt/gunbot/config.js > /tmp/config2.js\n" >> gunbot/startup.sh \
  && printf "jq '.bot.json_output = \"/opt/gunbot/json\"' /tmp/config2.js > /opt/gunbot/config.js\n" >> gunbot/startup.sh \
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
  && apk add --no-cache chrony libc6-compat gcompat libstdc++ jq \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x /opt/gunbot/startup.sh

EXPOSE ${GUNBOTPORT}
CMD ["sh","/opt/gunbot/startup.sh"]
