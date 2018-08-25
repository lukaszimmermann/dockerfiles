FROM lukaszimmermann/arvados-sso:latest as build
LABEL maintainer="luk.zim91@gmail.com"

# This is a tmpdir this image, since the data will be copied to another
# image later
ENV PGDATA /tmp/postgresdata

WORKDIR /tmp
RUN apt-get update -y && \
    apt-get install -y --no-install-suggests --no-install-recommends wget && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      postgresql-10 \
      postgresql-client-10
USER postgres
RUN ruby -e 'puts rand(2**128).to_s(36)' > /tmp/dbpass && sync && \
    /usr/lib/postgresql/10/bin/initdb \
      --username=postgres \
      -D "${PGDATA}" \
      --locale="${LANG}" && \
    /usr/lib/postgresql/10/bin/pg_ctl \
      -D "${PGDATA}" \
      -w \
      -t 10 \
      start && \
    /usr/lib/postgresql/10/bin/psql \
      -e \
      -c "CREATE ROLE arvados_sso PASSWORD '$(cat /tmp/dbpass)' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;" && \
    /usr/lib/postgresql/10/bin/psql \
      -e \
      -c "CREATE DATABASE arvados_sso_production OWNER arvados_sso ENCODING 'UTF8' TEMPLATE template0;" && \
    /usr/lib/postgresql/10/bin/pg_ctl -D "${PGDATA}" -w -t 10 -m smart stop && sync


##################################################
FROM alpine:3.8 as data
COPY --from=build /tmp/postgresdata /opt/data
COPY --from=build /tmp/dbpass /tmp/dbpass
COPY entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

