FROM ubuntu:18.04

# https://github.com/greenplum-db/gpdb/releases

# settings from https://github.com/kevinmtrowbridge/greenplumdb_singlenode_docker/blob/master/Dockerfile
# for cent os 6 https://github.com/kevinmtrowbridge/greenplumdb_singlenode_docker/blob/master/Dockerfile

RUN apt-get update && apt install -y \
      libapr1 \
      libaprutil1 \
      krb5-multidev \
      libcurl3-gnutls \
      libcurl4 \
      libevent-2.1-6 \
      libreadline7 \
      libxml2 \
      libyaml-0-2 \
      libldap-2.4-2 \
      openssh-client \
      openssh-server \
      openssl \
      perl \
      rsync \
      zip \
      net-tools \
      less \
      iproute2 \
      locales \
      wget \
      iputils-ping

RUN groupadd -g 8000 gpadmin
RUN useradd -m -s /bin/bash -d /home/gpadmin -g gpadmin -u 8000 gpadmin

WORKDIR /home/gpadmin
COPY bash/.gpadmin_bash_profile .bash_profile
COPY bash/start.sh start.sh
COPY gpdb/gpinitsystem_singlenode gpinitsystem_singlenode
COPY gpdb/hostlist_singlenode hostlist_singlenode
#
RUN chown -R gpadmin:gpadmin /home/gpadmin

#
##RUN wget -O /home/gpadmin/gpdb.deb https://github.com/greenplum-db/gpdb/releases/download/6.10.1/greenplum-db-6.10.1-ubuntu18.04-amd64.deb
COPY gpdb.deb gpdb.deb
#
RUN apt install /home/gpadmin/gpdb.deb
RUN chown -R gpadmin:gpadmin /usr/local/greenplum*
RUN chmod +x start.sh
#
RUN locale-gen "en_US.UTF-8"

RUN su gpadmin bash -l -c "/home/gpadmin/start.sh"
#
#ENV GPHOME /usr/local/greenplum-db
#
#RUN su gpadmin "/usr/local/greenplum-db-6.10.1/bin/gpinitsystem -a -D -c /home/gpadmin/gpinitsystem_singlenode"
#
#EXPOSE 5432
#
#
#RUN rm /home/gpadmin/gpdb.deb

RUN echo $(ls -1 /home/gpadmin)
RUN echo $(ls -1 /usr/local/greenplum-db-6.10.1)
RUN echo $(whoami)
