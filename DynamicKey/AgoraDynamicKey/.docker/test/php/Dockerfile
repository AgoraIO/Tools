ARG BASE_IMAGE=php:8.3
FROM ${BASE_IMAGE}

RUN apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 install -y --no-install-recommends ${PHPIZE_DEPS} \
        ca-certificates \
        curl \
    && mkdir -p /tmp/xdebug-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/xdebug/xdebug/tar.gz/refs/tags/3.3.2 \
        | tar -xz --strip-components=1 -C /tmp/xdebug-source \
    && cd /tmp/xdebug-source \
    && phpize \
    && ./configure --enable-xdebug \
    && make -j"$(nproc)" \
    && make install \
    && docker-php-ext-enable xdebug \
    && rm -rf /tmp/xdebug-source \
    && rm -rf /var/lib/apt/lists/*
