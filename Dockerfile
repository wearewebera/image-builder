FROM "gcr.io/huntingmill/common/base" AS base

ENV DEBIAN_FRONTEND noninteractive
ENV RELEASE_VERSION v0.17.0
ENV PATH /usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/root/bin:/root/bin/google-cloud-sdk/bin

WORKDIR /root

RUN apt-get update \
  && apt-get install -y \
  build-essential \
  git \
  uuid \
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

# operator-sdk
RUN curl -OJL https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu \
  && chmod +x operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu \
  && mv operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu /usr/local/bin/operator-sdk

# PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp
