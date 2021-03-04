FROM php:7.3-fpm

# Set working directory
CMD mkdir /var/www/laravel -p
WORKDIR /var/www/laravel

# Install dependencies
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    unzip \
    zip \ 
    libldb-dev \
    libldap2-dev \
    nano \
    git \
    curl


#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip


# Copy existing application directory permissions
RUN chown www-data:www-data * -R

# Change current user to www | for debug comment this
#USER www-data  #does not work yet due to permission issues

#Start app // disable app exit.
CMD ["tail", "-f", "/dev/null"]
