FROM php:7.3-fpm

# Set working directory
RUN mkdir /var/www/laravel -p
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

#install NPM
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn


#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN chmod +x composer.phar


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring ldap zip

#import entrypoint 
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Copy existing application directory permissions
RUN chown www-data:www-data /var/www/laravel/ -R

# Change current user to www | for debug comment this
# does not work yet due to permission issues
#USER www-data  

ENTRYPOINT [ "/var/www/laravel/entrypoint.sh" ]

#Start app // disable app exit.
#CMD ["tail", "-f", "/dev/null"]
