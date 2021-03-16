#!/bin/bash

cd /var/www/laravel/

setup () {
    if [ -d './app' ]; then 
      if [[ $(ls ./app | wc -l) < 1 ]]; then 
        git clone $APP_REPO app
        cd /var/www/laravel/app
        git checkout $APP_REPO_BRANCH
        cp .env.example .env
        echo -e "\nNow in $PWD: \n$(ls -laA)\n\nEdit the .env file and run 'init'\n"
      else 
        echo "folder ./app not empty.. unable to setup.. running init instead"
        init
      fi
    else 
      echo "use docker-compose with volume './app:/var/www/laravel/app' "
    fi
}

init () {
    cd /var/www/laravel/app
    if [ -f .env ]; then
      if [ $(diff .env .env.example | wc -l) > 0 ]; then
        php ../composer.phar update
        php ../composer.phar install
        php artisan key:generate #needs .env
        echo "starting application"
        run
      else 
        echo ".env not changed"
      fi
      
    else 
      echo ".env missing"
    fi
}

run () {
    cd /var/www/laravel/app
    if [[ -f .env ]]; then
      if [[ $(diff .env .env.example | wc -l) > 0 ]]; then
        php artisan config:cache
        php artisan migrate
        php artisan serve --port=8080 --host=app
      else 
        echo ".env not changed"
      fi
      
    else 
      echo ".env missing"
    fi
}

if [ "$1" = 'init' ]; then
	init
elif [ "$1" = 'setup' ]; then
  REPO=$2
  BRANCH=$3
	setup
elif [ "$1" = 'run' ]; then
  run
elif [ "$1" = 'composer' ]; then
  cd /var/www/laravel/app
  php ../composer.phar  "${@:(2):(-1)}"
elif [ "$1" = 'artisan' ]; then
  cd /var/www/laravel/app
  php artisan "${@:(2):(-1)}"
elif [ "$1" = 'git' ]; then
  cd /var/www/laravel/app
  git "${@:(2):(-1)}"
else 
	echo "Not sure what to do; k tnx bye"
fi
