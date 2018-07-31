FROM python:3.6.6-slim-stretch
LABEL maintainer="luk.zim91@gmail.com"

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        	libglib2.0-0 && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U numpy && \
    pip install --no-cache-dir -U pyopenms==2.3.0.4 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

