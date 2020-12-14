![Docker](https://github.com/VSLCatena/docker-laravel/workflows/Docker/badge.svg)

*Docker container for laravel apps, in this case vslcatena/mensa*

APP_NAME = mensa (must be EXACTLY the same as repo name!)

APP_REPO = https://github.com/vslcatena/mensa.git

# Contents

- [Changelog](#changelog)
- [Purpose](#purpose)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Steps](#steps)
- [Dir & Files](#dir--files)
  - [Before initialize](#before-initialize)
  - [After initialization](#after-initialization)
- [Advanced](#advanced)
  - [Alternative use for this repo](#alternative-use-for-this-repo)
  - [Git commit / push in Laravel App](#git-commit--push-in-laravel-app)
- [Troubleshoot](#troubleshoot)

# Changelog
- Initial commit
  - basic non-working app
- Revised build and docker-compose.yml
  - port bind on 1234
  - clear folder structure
  - bind mount on laravel-app folder and sql database for persistent storage.
  - README.md
  - 


# Purpose
- Easy spawn of mensa app
- No 'installation' on host device
- Instant edit of Laravel app files
- Standardize environment of Laravel App


# Installation 

## Dependencies
- https://github.com/vslcatena/mensa or any other laravel app

- Time... On a Raspberry Pi4 this takes about 23 minutes. Primarily due to the Laravel packages in build process (*Step 13/18 : RUN php ./composer.phar install*).

## Steps

1. ```git clone https://github.com/vslcatena/docker-laravel``` 

2. Get .env.example from your repo and fill in your variables

3. Check configuration in docker-compose 

4. ```screen -R APP_NAME```

5. ```docker-compose up --build``` 
6. Wait 25 minutes , grab some coffee
7. Access your server files on ./laravel-app/APP_NAME (instant-edit using bind mount)
8. Visit Laravel website on http://{docker-host}:1234

![alt text](https://user-images.githubusercontent.com/12066560/89425998-f1ea6700-d739-11ea-8058-f7dcaeb96cf4.png)

# Dir & Files
## Before initialize
- Dockerfile
- docker-compose.yml
- README.md

## After initialization
- above mentioned files
- ./etc
  -  config of php
  -  config of mysql
  -  config of apache2
- ./laravel-app/APP_NAME
  - laravel app APP_NAME
- .env
  - configuration of application


## Git commit / push in Laravel App
1. Go to ./laravel-app/{laravel_app_name}
2. Do git stuff


# Troubleshoot
- App wont start.
  - Check error in build and report back with issue


- How to start over?
  - Remove ./laravel-app 
  - Remove ./etc
  - Remove all older images and containers
    - `docker image prune`
    - `docker container prune`
    - `docker image rm {REPOSITORY_IMAGE_NAME ie. 'docker-mensa_app'}`
