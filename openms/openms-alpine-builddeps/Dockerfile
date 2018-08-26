FROM alpine:3.8
LABEL maintainer="luk.zim91@gmail.com"

# Here we download Qt to alpine in a version that is suitable for the
# building OpenMS. Also, we install the latest contrib library
WORKDIR /tmp
RUN apk update --no-cache -U && \
    apk add --no-cache -U  \
      autoconf \
      automake \
      cmake \
      git \
      g++ \
      libtool \
      linux-headers \
      make \
      patch && \
    mkdir -p /opt && sync && \
    wget -q https://download.qt.io/archive/qt/5.11/5.11.1/submodules/qtbase-everywhere-src-5.11.1.zip && sync && \
    unzip qtbase-everywhere-src-5.11.1.zip > /dev/null 2>&1 && sync && \
    rm qtbase-everywhere-src-5.11.1.zip && sync && \
    find /tmp/qtbase-everywhere-src-5.11.1 -type f -exec dos2unix {} \; && sync && \
    chmod -R ugoa-w /tmp/qtbase-everywhere-src-5.11.1 && \
    mkdir -p /tmp/configure && \
    cd /tmp/configure && \
    /tmp/qtbase-everywhere-src-5.11.1/configure \
      -prefix /opt/qtbase-everywhere-src-5.11.1-build \
      -opensource \
      -confirm-license \
      -release \
      -recheck-all \
      -static \
      -strip \
      -nomake tools \
      -nomake examples \
      -nomake tests \
      -no-widgets \
      -no-gtk \
      -no-cups \
      -no-gif \
      -no-ico \
      -no-libjpeg \
      -no-sqlite \
      -no-opengl \
      -no-evdev \
      -no-harfbuzz \
      -no-dbus  \
      -no-feature-regularexpression && \
      make && \
      make install && sync && \
    cd /tmp && \
    rm -rf /tmp/qtbase-everywhere-src-5.11.1 && \
    git clone https://github.com/OpenMS/contrib.git && \
    mkdir -p /opt/contrib-build && \
    cd /opt/contrib-build &&  \
    cmake -DBUILD_TYPE=ALL /tmp/contrib && \
    sed -i 's/PAGESIZE/page_size/g' /opt/contrib-build/include/seqan/file/string_external.h && \
    sed -i 's/PAGESIZE/page_size/g' /opt/contrib-build/include/seqan/file/file_page.h && \
    rm -rf CMakeCache.txt \
       CMakeFiles \
       Makefile \
       contrib.txt \
       archives \
       bin \
       README_contrib.txt \
       cmake_install.cmake \
       contrib_build.log \
       src  \
       lib/*.so* \
       /tmp/* \
       /var/tmp/* && sync

