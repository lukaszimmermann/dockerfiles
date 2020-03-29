FROM mayanedms/mayanedms:3.3
LABEL maintainer="luk.zim91@gmail.com"

RUN apt-get update -yqq && \
    apt-get install -yqq tesseract-ocr-deu && \
    apt-get autoclean -yqq && \
    apt-get clean -yqq && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && sync

