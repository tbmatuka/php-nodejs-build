FROM ubuntu:20.04

MAINTAINER Tin Benjamin Matuka <mail@tbmatuka.com>

# set up timezone
ENV TIMEZONE="UTC"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install deps, apache, php and php modules all in one run and clean up afterwards to reduce the snapshot size
RUN apt-get clean && \
    apt-get -y update && \
    apt-get install -y --force-yes \
        locales \
        curl \
        software-properties-common \
        git \
        apt-transport-https \
        sudo \
        nvi \
        iproute2 \
        telnet \
        dnsutils \
        unzip \
        rsync \
        inetutils-ping && \
    locale-gen en_US.UTF-8 && \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
        imagemagick \
        php7.0 php7.0-amqp php7.0-apcu php7.0-apcu-bc php7.0-bcmath php7.0-bz2 php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-gd php7.0-gmp php7.0-imagick php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mailparse php7.0-mbstring php7.0-mcrypt php7.0-memcache php7.0-memcached php7.0-mongodb php7.0-mysql php7.0-odbc php7.0-opcache php7.0-pgsql php7.0-pspell php7.0-readline php7.0-recode php7.0-redis php7.0-snmp php7.0-soap php7.0-sodium php7.0-sqlite3 php7.0-tideways php7.0-tidy php7.0-uuid php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-yaml php7.0-zip php7.0-zmq \
        php-phalcon \
        php-mail && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set php version as active
RUN update-alternatives --set php "/usr/bin/php7.0"

# add www-data to sudoers
COPY ./sudoers /etc/sudoers.d/www-data

# prepare www-data to be used as main user
RUN usermod -s /bin/bash -G staff www-data && \
    mkdir -p /var/www /app && \
    touch /var/www/.bash_profile && \
    chown -R www-data. /var/www /app

# install composer
RUN curl https://getcomposer.org/composer-1.phar > composer1 && \
    curl https://getcomposer.org/composer-2.phar > composer && \
    mv composer1 composer /usr/local/bin/ && \
    chown www-data:www-data /usr/local/bin/composer1 /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer1 /usr/local/bin/composer

# install yarn without nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install nvm
RUN sudo -i -u www-data sh -c 'curl -sL -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh" | bash'

# this lets us make our build behave differently if needed
ENV DOCKER="yes"

# prepare entrypoint and default command
COPY ./entrypoint.sh /usr/local/bin/

WORKDIR /app/

USER www-data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bash", "--login"]
