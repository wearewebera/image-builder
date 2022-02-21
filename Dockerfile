FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/root/bin:/root/bin/google-cloud-sdk/bin
ENV PYTHON_VERSION=3.10

WORKDIR /root

RUN apt-get update \
  && apt-get install -y \
  build-essential \
  git \
  uuid \
  software-properties-common \
  gettext-base \
  mysql-client \
  php-fpm \
  php-common \
  php-mysql \
  php-xmlrpc \
  php-curl \
  php-gd \
  php-imagick \
  php-dev \
  php-imap \
  php-mbstring \
  php-soap \
  php-zip \
  php-bcmath \
  php-xml \
  php-intl \
  php-cli \  
  nodejs \
  npm \
  && npm install -g npm yarn \    
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://raw.githubusercontent.com/wearewebera/tools/main/essentials.sh .
RUN bash essentials.sh \
  && rm essentials.sh

# Install python requirements
COPY requirements.txt .

RUN pip install -r requirements.txt

# PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp
