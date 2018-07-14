FROM alpine:3.7 as build_gcc

WORKDIR /tmp
RUN apk update --no-cache --update-cache && \
    apk upgrade --no-cache --update-cache && \
    apk add --no-cache --update-cache build-base gcc wget
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.gz
RUN mkdir -p /opt
RUN tar xf gcc-5.4.0.tar.gz
RUN rm gcc-5.4.0.tar.gz
WORKDIR /tmp/gcc-5.4.0
RUN ./contrib/download_prerequisites
WORKDIR /tmp/objdir
RUN /tmp/gcc-5.4.0/configure \
        --prefix=/opt/gcc-5.4.0  \
        --enable-languages=c \
        --enable-threads  \
        --enable-__cxa_atexit \
        --enable-default-pie \
        --enable-cloog-backend \
        --enable-shared \
        --enable-tls \
        --enable-checking=release \
        --disable-multilib \
        --disable-multiarch \
        --disable-nls \
        --disable-libsanitizer \
        --disable-libmudflap \
        --disable-libmpx \
        --disable-libssp  \
        --disable-vtable-verify  \
        --disable-browser-plugin \
        --disable-gtk-cairo \
        --disable-fixed-point \
        --disable-libstdcxx-pch \
        --disable-werror \
        --disable-symvers \
        --with-abi=m64 \
        --with-tune=generic \
        --with-pkgversion='Alpine 6.4.0' \
        --with-system-zlib \
        --with-linker-hash-style=gnu \
        --build=x86_64-linux-gnu \
        --host=x86_64-linux-gnu \
        --target=x86_64-linux-gnu
RUN make
RUN make check
RUN make install


#############################################################################
### Stage: production
##############################################################################
FROM alpine:3.7
WORKDIR /opt
COPY --from=build_gcc /opt/gcc-5.4.0 .
