FROM mysql:8.0.22
ARG DEBIAN_FRONTEND=noninteractive

ENV MYSQL_ROOT_PASSWORD=dees
ENV MYSQL_USER=seed 
ENV MYSQL_PASSWORD=dees
ENV MYSQL_DATABASE=elgg_seed

COPY elgg.sql  /docker-entrypoint-initdb.d
