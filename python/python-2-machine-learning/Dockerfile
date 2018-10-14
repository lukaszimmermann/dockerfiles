FROM python:2.7.15-alpine3.7

RUN apk add --no-cache \
        --virtual=.build-dependencies \
        g++ gfortran file binutils \
        musl-dev python-dev openblas-dev freetype-dev && \
    apk add --no-cache libpng && \
    pip install --no-cache-dir numpy && \
    pip install --no-cache-dir pandas && \
    pip install --no-cache-dir scipy && \
    pip install --no-cache-dir powerlaw && \
    pip install --no-cache-dir matplotlib && \
    pip install --no-cache-dir networkx && \
    pip install --no-cache-dir scikit-learn && \
    pip install --no-cache-dir tensorflow && \
    pip install --no-cache-dir keras && \
    pip install --no-cache-dir pytorch && \
    find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/lib/python3.*/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
    apk del .build-dependencies && \
    rm -rf /root/.cache /var/tmp/* /tmp/*

