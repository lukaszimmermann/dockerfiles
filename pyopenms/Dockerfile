FROM python:3.6.6-alpine3.8

WORKDIR /opt
RUN apk update --no-cache --update-cache && \
    apk add --no-cache --update-cache --virtual .builddeps \
       autoconf \
       automake \
       cmake  \
       gcc \
       g++ \
       git \
       libtool \
       make \
       musl-dev \
       patch &&  \
    pip install --no-cache-dir -U setuptools && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U autowrap && \
    pip install --no-cache-dir -U nose && \
    pip install --no-cache-dir -U numpy  && \
    pip install --no-cache-dir -U wheel && \
    git clone https://github.com/OpenMS/OpenMS.git && \
    cd /opt/OpenMS && \
    git submodule init && \
    git submodule update --remote --recursive contrib && \
    mkdir -p /opt/contrib-build && \
    cd /opt/contrib-build && \
    cmake -DBUILD_TYPE=ALL /opt/OpenMS/contrib && \
    rm -rf /opt/contrib-build/CMakeCache.txt \
           /opt/contrib-build/CMakeFiles \
           /opt/contrib-build/Makefile \
           /opt/contrib-build/README_contrib.txt \
           /opt/contrib-build/archives \
           /opt/contrib-build/bin \
           /opt/contrib-build/cmake_install.cmake\
           /opt/contrib-build/contrib_build.log \
           /opt/contrib-build/src \
           /tmp/* \
           /var/tmp/* && \
    mkdir -p /opt/OpenMS-build && \
    cd /opt/OpenMS-build && \
    cmake -DOPENMS_CONTRIB_LIBS=/opt/contrib-build \
          -DCMAKE_BUILD_TYPE=Release \
          -DWITH_GUI=Off \
          -DENABLE_TUTORIALS=Off \
          -DPYOPENMS=ON \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
         /opt/OpenMS && \
    make OpenMS pyopenms && \
    make install && \
    apk del .builddeps && \ 
    rm -rf /opt/* /var/tmp/* /tmp/*

