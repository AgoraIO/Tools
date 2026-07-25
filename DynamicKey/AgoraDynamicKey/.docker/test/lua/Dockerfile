ARG BASE_IMAGE=nickblah/lua:5.4.7-luarocks-ubuntu
FROM ${BASE_IMAGE}

ARG APT_MIRROR

RUN if [ -n "${APT_MIRROR}" ]; then \
        sed -i "s|http://ports.ubuntu.com/ubuntu-ports|${APT_MIRROR%/}|g" /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    fi \
    && apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=30 install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        libssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install base64

RUN luarocks install luaossl

RUN mkdir -p /tmp/luaunit-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/bluebird75/luaunit/tar.gz/refs/tags/LUAUNIT_V3_5 \
        | tar -xz --strip-components=1 -C /tmp/luaunit-source \
    && cd /tmp/luaunit-source \
    && luarocks make --deps-mode=none packaging/luaunit-3.5-1.rockspec \
    && rm -rf /tmp/luaunit-source

RUN mkdir -p /tmp/luafilesystem-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/lunarmodules/luafilesystem/tar.gz/refs/tags/v1_8_0 \
        | tar -xz --strip-components=1 -C /tmp/luafilesystem-source \
    && cd /tmp/luafilesystem-source \
    && luarocks make --deps-mode=none luafilesystem-scm-1.rockspec \
    && rm -rf /tmp/luafilesystem-source

RUN mkdir -p /tmp/luacov-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/lunarmodules/luacov/tar.gz/refs/tags/v0.15.0 \
        | tar -xz --strip-components=1 -C /tmp/luacov-source \
    && cd /tmp/luacov-source \
    && luarocks make --deps-mode=none luacov-scm-1.rockspec \
    && rm -rf /tmp/luacov-source

# Build rocks whose published rockspecs redirect through an unreliable GitHub endpoint.
RUN mkdir -p /tmp/md5-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/keplerproject/md5/tar.gz/refs/tags/1.3 \
        | tar -xz --strip-components=1 -C /tmp/md5-source \
    && cd /tmp/md5-source \
    && luarocks download --rockspec md5 1.3-1 \
    && luarocks make md5-1.3-1.rockspec \
    && rm -rf /tmp/md5-source

RUN mkdir -p /tmp/lua-zlib-source \
    && curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 120 https://codeload.github.com/brimworks/lua-zlib/tar.gz/refs/tags/v1.4 \
        | tar -xz --strip-components=1 -C /tmp/lua-zlib-source \
    && cd /tmp/lua-zlib-source \
    && luarocks download --rockspec lua-zlib 1.4-0 \
    && luarocks make lua-zlib-1.4-0.rockspec \
    && rm -rf /tmp/lua-zlib-source
