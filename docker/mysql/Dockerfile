FROM mysql:5.6
RUN apt-get update && apt-get install -y pv
COPY resources/my.cnf /etc/mysql/my.cnf
CMD ["mysqld"]
