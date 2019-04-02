FROM python:3.7.3-alpine3.9
LABEL maintainer="luk.zim91@gmail.com"

RUN cd /tmp && \
    apk update --no-cache -U && \
    apk add --no-cache -U --virtual .builddeps \
      git && \
    git clone -b master https://github.com/thehyve/python_transmart_loader && \
    cd python_transmart_loader && \
    git checkout befbef4e4912dcbb2bf40343fb2e5fa1d242429b && \
    pip install --no-cache-dir . && \
    cd examples/fhir2transmart && \
    pip install --no-cache-dir . && \
    python setup.py test && \
    apk del --purge .builddeps && \
    rm -rf /tmp/* /var/tmp/* && sync
ENTRYPOINT [ "python", "-m", "fhir2transmart.fhir2transmart" ]
