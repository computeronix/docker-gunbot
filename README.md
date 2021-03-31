# Dockerized Gunbot - POC - Unoffical
>* A containerized version of Gunbot.com.  Autobuilds the latest release and allows for an entire Gunbot.com to be setup in less than 1 minute.
>* More capabilities and features to come - ALPHA - Proof of Concept release
>* Requires Gunbot license which can be purchased from any of the approved [Gunbot resellers](https://gunthy.org/resellers/).
>* Note: Data loss may occur in the current state --> first feature being vetted and worked on to allow for persistant data

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)

## General info
Add more general information about project. What the purpose of the project is? Motivation?

## Screenshots
![Example screenshot](./img/screenshot.png)

## Technologies
* Tech 1 - version 1.0
* Tech 2 - version 2.0
* Tech 3 - version 3.0

## Setup
Describe how to install / setup your local environement / add link to demo version.

## Code Examples
Show examples of usage:
`put-your-code-here`

## Features
List of features ready and TODOs for future development
* Awesome feature 1
* Awesome feature 2
* Awesome feature 3

Roadmap:
* Wow improvement to be done 1
* Wow improvement to be done 2

Sets up gunbot (with systemctl to run in the background) and includes chrony to keep time

Requirements to run - host needs to supply SYS_TIME permissions (working to look for this permission and ignore and workaround if the host is unable to supply these (restart the container every hour or so)

the built-in start-up script performs the following
+syncs host volume data to container and looks for difference in gunbot data (gunbot data is ignored and not overwritten only processes)
+systemctl processes are enabled (chrony and gunbot)
+forever script starts to ensure container doesn't close

Default port: 5000 -> expose to host to access can be any port you want

example to get started with recommended commands - data persists (note it takes about 5 minutes to start if your host directory is empty - future start times are about 2 minutes or less)

docker run -d --cap-add=SYS_TIME -p 5000:5000 -v "/host/directory/to/volume:/tmp/gunbot" computeronix/gunbot:gunbot-ubuntu-latest

Advanced users: add bash/sh to override startup script docker run -d --cap-add=SYS_TIME -p 5000:5000 -v "/host/directory/to/volume:/tmp/gunbot" computeronix/gunbot:gunbot-ubuntu-latest bash

Run the file /tmp/startup.sh when ready to fire off the bot

will write troubleshooting article and how to connect in to pull gunbot.service data if needed

Submit issues/feedback/feature requests at the linked GitHub site

File locations: /opt/gunbot -> gunbot stuff /var/log/journal/gunbot.service -> gunbot console log /tmp/startup.sh (auto executes using default command above)


Attach to a running container:

docker exec -it id/nameofcontainer bash


Roadmap +mounting volume support is coming soon to then look for data files and take action from there -v "/full/path/host/gunbot/files:/opt/gunbot" -> right now clears the folder also will need to de-couple gunbot processes from data

#eventually add checks for failure of chrony or gunbot and then report back
#https://docs.docker.com/config/containers/multi-service_container/

#dynamically find gunthy-linux name for service in case it changes

#not working yet -> redirect logs to opt/gunbot ? right now in /var/log/journal/gunbot.service the console logs go here (outside standard logs that go to /opt/gunbot folder)

&& printf "StandardOutput=file:/opt/${GUNBOTDIR}/srvout.log\n" >> ${GUNBOTSERVICEFILE} \
&& printf "StandardError=file:/opt/${GUNBOTDIR}/srverr.log\n" >> ${GUNBOTSERVICEFILE} \
#eventually consider a healthcheck for the service and flag possibly chroncy service (for advanced users this would fail until chronyc service starts - would require SYS_TIME) #HEALTHCHECK --interval=60s --timeout=5s \

CMD chronyc tracking || exit 1
adjust startup script to provide further checks #provide script to enable service chrony and gunbot by default, if parameters provided script would be overrided for advanced users

connect other add-ins from marketplace either in a container or other containers (further review)

Add more distros (alpine / windows / macos support)

Check for beta releases and add a beta channel 
