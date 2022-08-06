# Dockerized Gunbot - POC - Unoffical
>* A containerized version of [Gunbot](https://gunthy.org/gunbot/).  Autobuilds the latest release and allows for an entire Gunbot.com to be setup in less than 1 minute.
>* More capabilities and features to come - ALPHA - Proof of Concept release
>* Requires Gunbot license which can be purchased from any of the approved [Gunbot resellers](https://gunthy.org/resellers/).
>* Betas are now supported, simply use "Support persistent data" and put gunthy-linux.zip (latest beta) in the persistent directory
>* Have your own SSL? imply use "Support persistent data" and put localhost.crt in the persistent directory
>* Note: Data loss may occur in the current state (in testing)

Default port: 5000 -> expose to host to access can be any port you want

Various command options:

Support host time:
add parameter --cap-add=SYS_TIME

Support port pass-through
add parameter -p 5000:5000

Support persistent data
add parameter -v "/host/directory/to/volume:/mnt/gunbot"

docker run -d computeronix/gunbot:latest

Support restarts if gunbot closes
add parameter --restart always

Advanced users:
add sh to override startup script docker run -it computeronix/gunbot:latest sh

If firing manually:
Run the file /opt/gunbot/startup.sh when ready to fire off the bot


Submit issues/feedback/feature requests at the linked GitHub site


###in progress - adding support for beta
###in progress - adding support for developer add-ins
