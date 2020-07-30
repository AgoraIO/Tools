FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer="shanhui@agora.io"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        uwsgi \
        uwsgi-plugin-python3 && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    Flask \
    Flask-APScheduler \
    numpy \
    Jinja2

ADD src /data/apps/token_service/src
ADD docker /data/apps/token_service
ADD docker/token_service.nginx.conf /etc/nginx/sites-enabled/default

WORKDIR /data/apps/token_service
RUN mkdir uwsgi log

ENTRYPOINT uwsgi_python36 --ini token_service.ini && nginx -g "daemon off;"

