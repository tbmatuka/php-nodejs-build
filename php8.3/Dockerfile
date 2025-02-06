FROM ubuntu:22.04

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
        php8.3 php8.3-amqp php8.3-apcu php8.3-bcmath php8.3-bz2 php8.3-cgi php8.3-cli php8.3-common php8.3-curl php8.3-dev php8.3-gd php8.3-gmp php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mailparse php8.3-mbstring php8.3-memcached php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pgsql php8.3-pspell php8.3-readline php8.3-redis php8.3-snmp php8.3-soap php8.3-sqlite3 php8.3-tidy php8.3-uuid php8.3-xml php8.3-xsl php8.3-yaml php8.3-zip php8.3-zmq \
        php-mail && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set php version as active
RUN update-alternatives --set php "/usr/bin/php8.3"

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

CMD []
