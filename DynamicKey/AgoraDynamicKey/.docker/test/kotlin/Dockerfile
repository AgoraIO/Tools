ARG BASE_IMAGE=maven:3.9.9-eclipse-temurin-8
FROM ${BASE_IMAGE}

ARG GRADLE_VERSION=8.1.1
ARG GRADLE_DISTRIBUTION_URL=https://services.gradle.org/distributions/gradle-8.1.1-bin.zip
ARG GRADLE_SHA256=e111cb9948407e26351227dabce49822fb88c37ee72f1d1582a69c68af2e702f

RUN curl -fsSL --retry 3 --retry-all-errors --connect-timeout 15 --max-time 300 \
        "${GRADLE_DISTRIBUTION_URL}" -o /tmp/gradle.zip \
    && echo "${GRADLE_SHA256}  /tmp/gradle.zip" | sha256sum -c - \
    && mkdir -p /opt/gradle \
    && cd /opt/gradle \
    && jar xf /tmp/gradle.zip \
    && chmod +x "/opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle" \
    && ln -s "/opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle \
    && rm /tmp/gradle.zip
