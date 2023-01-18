![docker build version](https://img.shields.io/docker/v/computeronix/gunbot?style=plastic) 
![docker build status](https://img.shields.io/docker/cloud/build/computeronix/gunbot?style=plastic) 
![docker build type](https://img.shields.io/docker/cloud/automated/computeronix/gunbot?style=plastic) 
![docker build size](https://img.shields.io/docker/image-size/computeronix/gunbot/latest?style=plastic) 
![docker build pulls](https://img.shields.io/docker/pulls/computeronix/gunbot?style=plastic) 
![docker build stars](https://img.shields.io/docker/stars/computeronix/gunbot?style=plastic)


# Gunbot - Unofficial - Docker Container

I have been a [Gunbot](https://gunthy.org/gunbot/) community member since 2019 and decided to help the community out with a need of a standardized containizered app of Gunbot for an easy to run setup.

This setup will allow for a vanilla, Gunbot setup, in less than a minute, allowing fully customizations, while providing one with the latest version, at all times.

# Highlights
Key capabilities of this Gunbot container:

- Latest version tag -> auto-builds with the latest stable version of Gunbot, when released
- Supports custom SSL certificate (requires using persistent data)
- Gunbot Betas are supported (requires using persistent data)
- [Gunthy Marketplace](https://marketplace.gunthy.io/) custom configs are supported (requires using persistent data)

# Licensing

First, Gunbot requires licensing to run and please check out the latest licensing details on the Gunbot Wiki at [Gunbot About Blockchain Licensing](https://wiki.gunthy.org/about/system-requirements/license-info#blockchain-based-license-system).

To acquire a license, please reach out to a [Gunbot Reseller](https://gunthy.org/resellers/) for more information.

# How to Get Started

## Quick Start Run
For the automated, quick start route, with your container tool, simply run
`docker run -d computeronix/gunbot:latest`

Once the image is downloaded, it will run and auto-start in usually about one minute or less.

If the port, by default 5000, is open on the host, and pass-thru the container, go to https://IPofCONTAINER:5000 (localhost could be used if local environment)

>PRO TIP: if this is the first time using Gunbot, or you need assistance setting up the config, open the port and pass-it through the container, then use the Web GUI to set it up. The Gunbot team has done an outstanding job with teh Web GUI!
>DO NOT forget to use the persistent data option below if you plan to keep your data

Example with persistant data and pass-through
`docker run -d computeronix/gunbot:latest -p 5000:5000 -v "/host/directory/to/volume:/mnt/gunbot"`

## Advanced Users Run

Interrupt the auto-start with the following command and feel free to do what you want:
`docker run -it computeronix/gunbot:latest sh`

You will then get shell access to the container and can do what you want.

>Run the file `/opt/gunbot/startup.sh` when ready to fire off the bot

# Defaults

Default values that are out of the box:

- Port: 5000 (TCP)
- HTTPS is enabled with a self-signed certificate
- Gunbot Betas are supported (requires using Persistant Data)
- Supports custom SSL certificate (requires using Persistant Data)

# Command Options Supported

Supported command options as part of the Docker container:

## Support Host Time

Gunbot is a time sensitive application, as accurate timestamps are critical to communicate to exchanges, and depending on how long the container runs for you "may" want to allow the permission to change the system time, OR, you may want to consider getting a fresh container every so often (no longer than every 24 hours).

The parameter `--cap-add=SYS_TIME` is supported to allow the change time permission to occur on the container, but this may not work on all hosting platforms.

Supported parameter: `--cap-add=SYS_TIME`

## Support Website GUI Pass-Through Port

You may want to allow passing through your Website GUI port to getting access to the Website Management GUI of your Gunbot. By default the port is TCP 5000, run this command to pass-through the port `-p 5000:5000` and this can be customized as needed. The first `5000` is the HOST port and can be the port used to access from your host (Internet) and the second `5000` is the port configured in your Gunbot config (by default `5000`).

Supported parameter: `-p 5000:5000`

>Do not forget to open any firewall restrictions on your HOST network (first 5000).
>
>Gunbot is intended to run on your local system. Making the Gunbot GUI available from outside networks is inherently risky, only do so on your own responsibility.
Considerable efforts went into securing the GUI, but please understand that achieving 100% security is not realistic.

## Support Persistent Data

Containers are ephermal, which means when they complete their task, they end, and all associated data is lost. If there is data you want to keep as part of the container ending, you will want to mount a directory to preserve this data.  Gunbot Docker container supports persistentance if you decide you want to keep your Gunbot data. To support persistance add the parameter `-v "/host/directory/to/volume:/mnt/gunbot"` and the following directories and files in `/mnt/gunbot` will be redirected and saved to your mounted volume, `/host/directory/to/volume`.

Persistent Gunbot Directories and Files:

- ssl.config (custom file for creating a self-signed file - docker related)
- localhost.key (for HTTPS)
- localhost.crt (for HTTPS)
- json directory
- logs directory
- backups directory
- customStrategies directory
- config.js
- UTAconfig.json
- autoconfig.json
- gunbotgui.db
- new_gui.sqlite

>DO NOT use more than one instance to the exact same `/host/directory/to/volume/`, instead make sure you use different directories, for example you could use subdirectories in `/host/directory/to/volume/sub1 sub2 sub3 etc` so multiple running containers will not conflict with each other.

Supported parameter: `-v "/host/directory/to/volume:/mnt/gunbot"`

**Support for betas**  
The Gunbot Docker Container supports beta releases! To utilize the latest release simply download the latest beta for Linux and move the beta zip, labeled as `gunthy-linux.zip` to the persistent directory `/host/directory/to/volume`.

When the container runs, it looks for `gunthy-linux.zip` (the latest beta) and will use this over the built-in application of the container.
>Note beta releases "should" operate the same as if you were running on a normal Linux distribution, but you may run into issues since they are beta and are meant for Advanced Users only. Be sure when reporting issues to the Gunbot Community you mention the beta is running **Gunbot Docker Container**, **using Alpine Linux**, and then the version of the Gunbot beta you provided.

**Support for Gunthy Marketplace configs and addons**  
Under Construction - In Testing

# Troubleshooting / Feedback / Issues

## Need Help with Gunbot?

Check out the Gunbot Wiki to [Learn how to use Gunbot | Gunbot docs (gunthy.org)](https://wiki.gunthy.org/)

>Gunbot Docker (Container) works exactly the same as if it is running on Linux directly

## Need Help or Have Feedback with Gunbot Docker

Submit issues/feedback/feature requests at the linked GitHub site

