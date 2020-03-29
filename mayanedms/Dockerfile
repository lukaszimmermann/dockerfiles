FROM mayanedms/mayanedms:3
LABEL maintainer="luk.zim91@gmail.com"

RUN apt-get update -yqq && \
    apt-get install -yqq tesseract-ocr-deu && \
    apt-get autoclean -yqq && \
    apt-get clean -yqq && \
    rm -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/* \
      /usr/share/man \
      /usr/share/doc \
      /usr/share/doc-base && sync

