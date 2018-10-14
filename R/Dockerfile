FROM r-base:3.5.1
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      libcurl4-openssl-dev \
      libgit2-dev \
      libssl-dev \
      libxml2-dev && \
    Rscript -e 'install.packages(c("devtools", "roxygen2", "RcppArmadillo"), dependencies=TRUE, clean=TRUE); update.packages(ask=FALSE, checkBuilt=TRUE);' && \
    rm -rf /tmp/* /var/tmp/*
WORKDIR /

