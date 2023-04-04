FROM php:8.1-apache

WORKDIR /var/www/html

RUN a2enmod rewrite

RUN apt-get update -y && apt-get install -y\
    libicu-dev\
    libmariadb-dev\
    unzip zip\
    zlib1g-dev\
    libpng-dev\
    libjpeg-dev\
    libfreetype6-dev\
    libjpeg62-turbo-dev\
    libpng-dev\
    libonig-dev\
    libzip-dev\
    libssl-dev\
    pkg-config\
    autoconf\
    curl git\
    vim nano\
&& apt-get update -y

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4 MySQL
RUN docker-php-ext-install bcmath mbstring intl opcache
RUN docker-php-ext-install pdo pdo_mysql mysqli

ENV NODE_VERSION=16.20.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version