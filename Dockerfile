FROM php:7.3-fpm
ARG APP_NAME
ARG APP_REPO
ARG APP_REPO_BRANCH

# Set working directory
CMD mkdir /var/www/laravel -p
WORKDIR /var/www/laravel

# Install dependencies
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    unzip \
    zip \ 
    libldb-dev \
    libzip-dev \
    libldap2-dev \
    nano \
    git \
    curl

# install app
RUN git clone $APP_REPO
WORKDIR /var/www/laravel/$APP_NAME
RUN git checkout $APP_REPO_BRANCH
ADD .env /var/www/laravel/$APP_NAME/

#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip

#initialize laravel dep
RUN php ./composer.phar update
RUN php ./composer.phar install

# Copy existing application directory permissions
RUN chown www-data:www-data * -R

#initialize app (run=build , cmd=start)
RUN php artisan key:generate #needs .env
CMD php artisan config:cache

#issue with persistent storage
WORKDIR /var/www/laravel
RUN mv /var/www/laravel /var/www/laravel.template
# Change current user to www | for debug comment this
#USER www-data  #does not work yet due to permission issues

#Start app // disable app exit.
CMD ["tail", "-f", "/dev/null"]
