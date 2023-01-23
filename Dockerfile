#VARIABLES
ARG GUNBOTVERSION="latest"
ARG GITHUBOWNER="GuntharDeNiro"
ARG GITHUBREPO="BTCT"
ARG GBINSTALLLOC="/opt/gunbot"
ARG GBMOUNT="/mnt/gunbot"
ARG GBBETA="gunthy-linux.zip"
ARG GBPORT=5000
ARG MAINTAINER="Gunbot"
ARG WEBSITE="https://www.gunbot.com/"
ARG DESCRIPTION="Gunbot is an easy to use, advanced crypto trading bot. You define or select a trading strategy and watch Gunbot trade. Enabling you to get up to hundreds of profitable trades per day, 24/7. - Docker Container - Alpine - ${GUNBOTVERSION}"

#SCRATCH WORKSPACE FOR BUILDING IMAGE
FROM alpine:latest AS gunbot-builder
ARG GUNBOTVERSION
ARG GITHUBOWNER
ARG GITHUBREPO
ARG GBINSTALLLOC
ARG GBBETA
ARG GBMOUNT
ARG GBPORT

WORKDIR /tmp

#BUILDING IMAGE
#update mirrors
RUN apk update \
  #install packages
  && apk add --no-cache wget jq unzip \
  #remove mirrors
  && rm -rf /var/lib/apt/lists/* \
  #pull ${GUNBOTVERSION} from official GitHub and extract linux client
  && wget -q -nv -O gunbot.zip $(wget -q -nv -O- https://api.github.com/repos/${GITHUBOWNER}/${GITHUBREPO}/releases/${GUNBOTVERSION} 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("gunthy_linux")) | .browser_download_url') \
  && unzip -d . gunbot.zip \
  && mv gunthy_linux gunbot \
  #create self-signed ssl configuratuon
  && printf "[req]\n" > gunbot/ssl.config \
  && printf "distinguished_name = req_distinguished_name\n" >> gunbot/ssl.config \
  && printf "prompt = no\n" >> gunbot/ssl.config \
  && printf "[req_distinguished_name]\n" >> gunbot/ssl.config \
  && printf "commonName = localhost\n" >> gunbot/ssl.config \
  #create startup.sh shell script
  && printf "#!/bin/sh\n" > gunbot/startup.sh \
  #check for persistent storage mount (${GBMOUNT})
  && printf "if [ ! -d ${GBMOUNT} ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  #check for Gunbot Beta (${GBBETA})
  && printf "if [ -f ${GBMOUNT}/${GBBETA} ]; then \n" >> gunbot/startup.sh \
  && printf "	unzip -d ${GBMOUNT} ${GBMOUNT}/${GBBETA}\n" >> gunbot/startup.sh \
  && printf "	mv ${GBMOUNT}/gunthy-linux ${GBINSTALLLOC}\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  #check for ssl.config
  && printf "if [ -f ${GBMOUNT}/ssl.config ]; then \n" >> gunbot/startup.sh \
  && printf "	ln -sf ${GBMOUNT}/ssl.config ${GBINSTALLLOC}/ssl.config\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  #check for localhost.crt AND localhost.key
  && printf "if [ ! -f ${GBMOUNT}/localhost.crt ] && [ ! -f ${GBMOUNT}/localhost.key ]; then \n" >> gunbot/startup.sh \
  && printf "	openssl req -config ${GBINSTALLLOC}/ssl.config -newkey rsa:2048 -nodes -keyout ${GBINSTALLLOC}/localhost.key -x509 -days 365 -out ${GBINSTALLLOC}/localhost.crt\n" >> gunbot/startup.sh \
  && printf "else\n" >> gunbot/startup.sh \
  && printf "   ln -sf ${GBMOUNT}/localhost.crt ${GBINSTALLLOC}/localhost.crt\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  #check for json directory
  && printf "if [ ! -d ${GBMOUNT}/json ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/json ${GBINSTALLLOC}/json\n" >> gunbot/startup.sh \
  #check for logs directory
  && printf "if [ ! -d ${GBMOUNT}/logs ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/logs\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/logs ${GBINSTALLLOC}/logs\n" >> gunbot/startup.sh \
  #check for backups directory
  && printf "if [ ! -d ${GBMOUNT}/backups ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/backups\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/backups ${GBINSTALLLOC}/backups\n" >> gunbot/startup.sh \
  #check for customStrategies directory
  && printf "if [ ! -d ${GBMOUNT}/customStrategies ]; then \n" >> gunbot/startup.sh \
  && printf "	mkdir ${GBMOUNT}/customStrategies\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/customStrategies ${GBINSTALLLOC}/customStrategies\n" >> gunbot/startup.sh \
  #check for config.js file
  && printf "if [ ! -f ${GBMOUNT}/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/config.js ${GBMOUNT}/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/config.js ${GBINSTALLLOC}/config.js\n" >> gunbot/startup.sh \
  #check for UTAconfig.json file
  && printf "if [ ! -f ${GBMOUNT}/UTAconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/UTAconfig.json ${GBMOUNT}/UTAconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/UTAconfig.json ${GBINSTALLLOC}/UTAconfig.json\n" >> gunbot/startup.sh \
  #check for autoconfig.json file
  && printf "if [ ! -f ${GBMOUNT}/autoconfig.json ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/autoconfig.json ${GBMOUNT}/autoconfig.json\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/autoconfig.json ${GBINSTALLLOC}/autoconfig.json\n" >> gunbot/startup.sh \
  #check for gunbotgui.db file
  && printf "if [ ! -f ${GBMOUNT}/gunbotgui.db ]; then \n" >> gunbot/startup.sh \
  && printf "	touch ${GBINSTALLLOC}/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/gunbotgui.db ${GBMOUNT}/gunbotgui.db\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/gunbotgui.db ${GBINSTALLLOC}/gunbotgui.db\n" >> gunbot/startup.sh \
  #check for new_gui.sqlite file
  && printf "if [ ! -f ${GBMOUNT}/new_gui.sqlite ]; then \n" >> gunbot/startup.sh \
  && printf "	touch ${GBINSTALLLOC}/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/new_gui.sqlite ${GBMOUNT}/new_gui.sqlite\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  && printf "ln -sf ${GBMOUNT}/new_gui.sqlite ${GBINSTALLLOC}/new_gui.sqlite\n" >> gunbot/startup.sh \
  #setup config.js
  && printf "if [ ! -s ${GBMOUNT}/config.js ]; then \n" >> gunbot/startup.sh \
  && printf "	cp ${GBINSTALLLOC}/config-js-example.txt ${GBMOUNT}/config.js\n" >> gunbot/startup.sh \
  && printf "fi\n" >> gunbot/startup.sh \
  #inject config -> enable https
  && printf "jq '.GUI.https = true' ${GBINSTALLLOC}/config.js > /tmp/config2.js\n" >> gunbot/startup.sh \
  #inject config -> setup json output -> /opt/gunbot/json
  && printf "jq '.bot.json_output = \"/opt/gunbot/json\"' /tmp/config2.js > /tmp/config3.js\n" >> gunbot/startup.sh \
  #inject config -> force port 5000
  && printf "jq '.GUI.port = ${GBPORT}' /tmp/config3.js > /tmp/config4.js\n" >> gunbot/startup.sh \
  #inject config -> setup localhost.key
  && printf "jq '.GUI.key = \"localhost.key\"' /tmp/config4.js > /tmp/config5.js\n" >> gunbot/startup.sh \
  #inject config -> setup localhost.crt
  && printf "jq '.GUI.cert = \"localhost.crt\"' /tmp/config5.js > ${GBINSTALLLOC}/config.js\n" >> gunbot/startup.sh \
  #run chronyd (note will not work without proper permissions and will error, but will continue forward)
  && printf "chronyd -d || :\n" >> gunbot/startup.sh \
  #run gunbot
  && printf "${GBINSTALLLOC}/gunthy-linux\n" >> gunbot/startup.sh


#BUILD THE RUN IMAGE
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
  && apk add --no-cache chrony libc6-compat gcompat libstdc++ libuuid1 jq unzip openssl \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x "${GBINSTALLLOC}/startup.sh"

EXPOSE ${GBPORT}
CMD ["sh","-c","${GUNBOTLOCATION}/startup.sh"]
