# (Unofficial) Gunbot Docker Container

## Docker Statistics

![docker build status](https://img.shields.io/docker/cloud/build/computeronix/gunbot?style=plastic)
![docker build type](https://img.shields.io/docker/cloud/automated/computeronix/gunbot?style=plastic)
![docker build pulls](https://img.shields.io/docker/pulls/computeronix/gunbot?style=plastic)
![docker build open issues](https://img.shields.io/github/issues/computeronix/docker-gunbot?style=plastic)
![docker build stars](https://img.shields.io/docker/stars/computeronix/gunbot?style=plastic)

### Stable Release 
![docker build version by latest stable version](https://img.shields.io/docker/v/computeronix/gunbot/latest?style=plastic)
![docker build size by latest stable version](https://img.shields.io/docker/image-size/computeronix/gunbot/latest?style=plastic)  

### Beta Release
![docker build version by latest beta version](https://img.shields.io/docker/v/computeronix/gunbot/beta?style=plastic)
![docker build size by latest beta version](https://img.shields.io/docker/image-size/computeronix/gunbot/beta?style=plastic)

## Introduction
I have been a [Gunbot](https://gunthy.org/gunbot/) community member since 2019 and decided to help the community out with a need of a standardized containizered app of Gunbot for an easy to run setup.

This setup will allow for a vanilla, Gunbot setup, in less than a minute, allowing fully customizations, while providing one with the latest version, at all times.

### Highlights
Key capabilities of this Gunbot container application:

- Auto-builds with the latest **stable** version of Gunbot, use the tag `:latest`
- Auto-builds with the latest **beta** version of Gunbot, use the tag `:beta`
- Multi-platform support ( `amd64` and `arm64` )
- Supports HTTPS by default with the Web GUI
- [Gunthy Marketplace](https://marketplace.gunthy.io/) custom scripts are supported (requires using persistent data)
- Listed on the Gunthy Marketplace, [check us out](https://marketplace.gunthy.io/extras/GunbotDocker)

## How to Get Started

### Docker Hub Repo
Access the [Docker Hub](https://hub.docker.com/r/computeronix/gunbot) to review tags and all the details of the container.

### Quick Start
For the automated, quick start route, with your container tool, simply run
```bash
docker run -d computeronix/gunbot:latest
```

Once the image is downloaded, it will run and auto-start in usually about one minute or less.

If the port, by default **5000**, is open on the host, go to `https://IPofCONTAINER:5000` (`localhost` could be used if local environment)

> PRO TIP: if this is the first time using Gunbot, or you need assistance setting up the config, open the port and pass-it through the container, then use the Web GUI to set it up. The Gunbot team has done an outstanding job with the Web GUI!  
  
> DO NOT forget to use the persistent data option below if you plan to keep your data

Example with persistent data and port pass-through
```bash
docker run -d computeronix/gunbot:latest -p 5010:5000 -v "/host/directory/to/volume:/mnt/gunbot"
```
In the above example, Gunbot would be available on `https://IPofCONTAINER:5010` and data would persist on the mounted directory `/host/directory/to/volume`.

## Support

### Need Help with Gunbot?

Check out the Gunbot Wiki to [Learn how to use Gunbot | Gunbot docs (gunthy.org)](https://wiki.gunthy.org/)

>Gunbot Docker (Container) works the same as if it is running on Linux directly

### Want more information on Gunbot Docker?
The detailed documentation on how to use the container, background, future roadmap, etc are all located on the [(Unofficial) Gunbot Docker Container Docs](https://docs.gunthy.trade/) site.

### Need Help or Have Feedback with Gunbot Docker?

 - Join the Telegram Community, ask the Gunbot School for access.
 - Submit issues/feedback/feature requests at the GitHub site, under [issues](https://github.com/computeronix/docker-gunbot/issues).
