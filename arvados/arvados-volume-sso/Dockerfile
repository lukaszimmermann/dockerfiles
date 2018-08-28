ARG PG_PASSWORD
FROM postgres:11-alpine as build 
LABEL maintainer="luk.zim91@gmail.com"

# This is a tmpdir this image, since the data will be copied to another
# image later
ENV PGDATA /tmp/postgresdata

# Create the Database and the Role for Arvados_SSO
USER postgres
RUN initdb --username=postgres -D "${PGDATA}" --locale="en_US.UTF-8" && \
    pg_ctl -D "${PGDATA}" -w -t 10 start && \
    psql -e -c "CREATE ROLE arvados_sso PASSWORD '${PG_PASSWORD}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;" && \
    psql -e -c "CREATE DATABASE arvados_sso_production OWNER arvados_sso ENCODING 'UTF8' TEMPLATE template0;" && \
    pg_ctl -D "${PGDATA}" -w -t 10 -m smart stop && sync

##################################################
FROM alpine:3.8 as data
COPY --from=build /tmp/postgresdata /opt/data
COPY entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

