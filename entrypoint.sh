#!/bin/sh

METHOD = $1
REPO = $2
BRANCH = $3

cd /var/www/laravel/

setup () {
    NAME = ${REPO#*//*/*/}
    git clone $REPO
    cd /var/www/laravel/$NAME
    git checkout $BRANCH
    cp .env.exanple .env


init () {
    cd $(ls   -d */ -1 | grep -A0 / -m1)
    php ./composer.phar update
    php ./composer.phar install
    php artisan key:generate #needs .env
}

run () {
    cd $(ls   -d */ -1 | grep -A0 / -m1)
    php artisan config:cache
    php artisan migrate
    php artisan serve --port=8080 --host=app
}


case $METHOD in

  setup)
    setup
    ;;

  init)
    init
    ;;

  run)
    run
    ;;

  *)
    echo -n "unknown argument"
    ;;
esac