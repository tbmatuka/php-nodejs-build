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
        php5.6 php5.6-amqp php5.6-apcu php5.6-bcmath php5.6-bz2 php5.6-cgi php5.6-cli php5.6-common php5.6-curl php5.6-dev php5.6-gd php5.6-gmp php5.6-imagick php5.6-imap php5.6-intl php5.6-json php5.6-ldap php5.6-mailparse php5.6-mbstring php5.6-mcrypt php5.6-memcache php5.6-memcached php5.6-mysql php5.6-odbc php5.6-opcache php5.6-pgsql php5.6-pspell php5.6-readline php5.6-recode php5.6-redis php5.6-snmp php5.6-soap php5.6-sqlite3 php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-xsl php5.6-yaml php5.6-zip php5.6-zmq \
        php-phalcon \
        php-mail && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set php version as active
RUN update-alternatives --set php "/usr/bin/php5.6"

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
