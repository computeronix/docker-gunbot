ARG GUNBOTVERSION="latest"
ARG GITHUBOWNER="GuntharDeNiro"
ARG GITHUBREPO="BTCT"
ARG GBINSTALLLOC="/opt/gunbot"
ARG GBMOUNT="/mnt/gunbot"
ARG GBBETA="gunthy-linux.zip"
ARG GBPORT=5000
ARG MAINTAINER="Gunthy"
ARG WEBSITE="https://github.com/GuntharDeNiro/BTCT"
ARG DESCRIPTION="docker file alpine, containerized gunbot - ${GUNBOTVERSION}"

FROM alpine:latest AS gunbot-builder
ARG GUNBOTVERSION
ARG GITHUBOWNER
ARG GITHUBREPO
ARG GBINSTALLLOC
ARG GBBETA
ARG GBMOUNT
ARG GBPORT

WORKDIR /tmp

RUN apk update \
  && apk add --no-cache wget jq unzip \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q -nv -O gunbot.zip $(wget -q -nv -O- https://api.github.com/repos/${GITHUBOWNER}/${GITHUBREPO}/releases/${GUNBOTVERSION} 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("gunthy_linux")) | .browser_download_url') \
  && unzip -d . gunbot.zip \
  && mv gunthy_linux gunbot \
  && printf "[req]\n" > gunbot/ssl.config \
  && printf "distinguished_name = req_distinguished_name\n" >> gunbot/ssl.config \
  && printf "prompt = no\n" >> gunbot/ssl.config \
  && printf "[req_distinguished_name]\n" >> gunbot/ssl.config \
  && printf "commonName = localhost\n" >> gunbot/ssl.config \
  && printf "#!/bin/sh\n" > gunbot/startup.sh \
  && printf "if [ ! -d ${GBMOUNT} ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "if [ -f ${GBMOUNT}/${GBBETA} ]; then \n" >> gunbot/startup.sh \
  && printf "	unzip -d ${GBMOUNT} ${GBMOUNT}/${GBBETA}\n" >> gunbot/startup.sh \
  && printf "	mv ${GBMOUNT}/gunthy-linux ${GBINSTALLLOC}\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "if [ -f ${GBMOUNT}/ssl.config ]; then \n" >> gunbot/startup.sh \
  && printf "	ln -sf ${GBMOUNT}/ssl.config ${GBINSTALLLOC}/ssl.config\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/localhost.crt ]; then \n" >> gunbot/startup.sh \
  && printf "	openssl req -config ${GBINSTALLLOC}/ssl.config -newkey rsa:2048 -nodes -keyout ${GBINSTALLLOC}/localhost.key -x509 -days 365 -out ${GBINSTALLLOC}/localhost.crt\n" >> gunbot/startup.sh \
  && printf "else\n" >> gunbot/startup.sh \
  && printf "   ln -sf ${GBMOUNT}/localhost.crt ${GBINSTALLLOC}/localhost.crt\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "if [ ! -d ${GBMOUNT}/json ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/json ${GBINSTALLLOC}/json\n" >> gunbot/startup.sh \
  && printf "if [ ! -d ${GBMOUNT}/logs ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/logs\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/logs ${GBINSTALLLOC}/logs\n" >> gunbot/startup.sh \
  && printf "if [ ! -d ${GBMOUNT}/backups ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/backups\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/backups ${GBINSTALLLOC}/backups\n" >> gunbot/startup.sh \
  && printf "if [ ! -d ${GBMOUNT}/customStrategies ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/customStrategies\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/customStrategies ${GBINSTALLLOC}/customStrategies\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/config.js ${GBMOUNT}/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/config.js ${GBINSTALLLOC}/config.js\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/UTAconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/UTAconfig.json ${GBMOUNT}/UTAconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/UTAconfig.json ${GBINSTALLLOC}/UTAconfig.json\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/autoconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/autoconfig.json ${GBMOUNT}/autoconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/autoconfig.json ${GBINSTALLLOC}/autoconfig.json\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/gunbotgui.db ]; then \n" >> gunbot/startup.sh \
  && printf "	touch ${GBINSTALLLOC}/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/gunbotgui.db ${GBMOUNT}/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/gunbotgui.db ${GBINSTALLLOC}/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "if [ ! -f ${GBMOUNT}/new_gui.sqlite ]; then \n" >> gunbot/startup.sh \
  && printf "	touch ${GBINSTALLLOC}/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/new_gui.sqlite ${GBMOUNT}/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/new_gui.sqlite ${GBINSTALLLOC}/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "if [ ! -s ${GBMOUNT}/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/config-js-example.txt ${GBMOUNT}/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "jq '.GUI.https = true' ${GBINSTALLLOC}/config.js > /tmp/config2.js\n" >> gunbot/startup.sh \
  && printf "jq '.bot.json_output = \"/opt/gunbot/json\"' /tmp/config2.js > /tmp/config3.js\n" >> gunbot/startup.sh \
  && printf "jq '.GUI.port = ${GBPORT}' /tmp/config3.js > /tmp/config4.js\n" >> gunbot/startup.sh \
  && printf "jq '.GUI.key = \"localhost.key\"' /tmp/config4.js > /tmp/config5.js\n" >> gunbot/startup.sh \
  && printf "jq '.GUI.cert = \"localhost.crt\"' /tmp/config5.js > ${GBINSTALLLOC}/config.js\n" >> gunbot/startup.sh \
  && printf "chronyd -d || :\n" >> gunbot/startup.sh \
  && printf "${GBINSTALLLOC}/gunthy-linux\n" >> gunbot/startup.sh


FROM alpine:latest
ARG MAINTAINER
ARG WEBSITE
ARG DESCRIPTION
ARG GBINSTALLLOC
ARG GBBETA
ARG GBPORT
ENV GUNBOTLOCATION=${GBINSTALLLOC}

LABEL \
  maintainer="${MAINTAINER}" \
  website="${WEBSITE}" \
  description="${DESCRIPTION}"

COPY --from=gunbot-builder /tmp/gunbot ${GBINSTALLLOC}

WORKDIR ${GBINSTALLLOC}

RUN apk update \
  && apk add --no-cache chrony libc6-compat gcompat libstdc++ jq unzip openssl \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x "${GBINSTALLLOC}/startup.sh"

EXPOSE ${GBPORT}
CMD ["sh","-c","${GUNBOTLOCATION}/startup.sh"]
