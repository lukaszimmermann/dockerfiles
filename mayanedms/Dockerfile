FROM mayanedms/mayanedms:latest
LABEL maintainer="luk.zim91@gmail.com"

RUN apt-get update -y && \
    apt-get install -y tesseract-ocr-deu && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /tmp/* /var/tmp/* && sync

