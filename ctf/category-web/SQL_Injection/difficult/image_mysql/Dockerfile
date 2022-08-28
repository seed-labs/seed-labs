FROM mysql:latest
ENV MYSQL_ROOT_PASSWORD="toor"
ENV MYSQL_USER="seed"
ENV MYSQL_PASSWORD="dees"
ENV MYSQL_DATABASE="ctf_sql"
COPY ./ctf_sql_database.sql /docker-entrypoint-initdb.d
