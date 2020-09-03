FROM ubuntu:18.04

# deb-package from https://github.com/greenplum-db/gpdb/releases
# linux commands from:
# https://github.com/greenplum-db/gpdb/blob/master/src/tools/docker/ubuntu16_ppa/README.md
# https://github.com/kevinmtrowbridge/greenplumdb_singlenode_docker/blob/master/Dockerfile
# https://github.com/greenplum-db/gpdb/blob/master/src/tools/docker/ubuntu/Dockerfile
# https://github.com/DataGrip/docker-env/blob/master/greenplum/6.8/Dockerfile
# https://github.com/greenplum-db/gpdb/blob/master/src/tools/docker/ubuntu16_ppa/Dockerfile

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
      iputils-ping \
      python-dev \
      python-pip \
      python-psutil \
      python-setuptools \
      ssh

# create user and group gpadmin
RUN groupadd -g 8000 gpadmin
RUN useradd -m -s /bin/bash -d /home/gpadmin -g gpadmin -u 8000 gpadmin

WORKDIR /home/gpadmin
COPY bash/.gpadmin_bash_profile .bash_profile
COPY gpdb/gpinitsystem_singlenode gpinitsystem_singlenode
COPY gpdb/hostlist_singlenode hostlist_singlenode

COPY bash/start.sh start.sh
RUN chmod +x start.sh

RUN chown -R gpadmin:gpadmin /home/gpadmin

#RUN wget -O /home/gpadmin/gpdb.deb https://github.com/greenplum-db/gpdb/releases/download/6.10.1/greenplum-db-6.10.1-ubuntu18.04-amd64.deb
COPY gpdb.deb gpdb.deb

RUN apt install /home/gpadmin/gpdb.deb
RUN rm /home/gpadmin/gpdb.deb

RUN mkdir -p /data/gpmaster /data/gpdata1 /data/gpdata2
RUN chown -R gpadmin:gpadmin /data

RUN chown -R gpadmin:gpadmin /usr/local/greenplum*
RUN locale-gen "en_US.UTF-8"
RUN service ssh start && su gpadmin bash -l -c "/home/gpadmin/start.sh" || /bin/true


RUN echo $(ls -1 /home/gpadmin)
RUN echo $(ls -1 /usr/local/greenplum-db-6.10.1)
RUN echo $(whoami)
RUN echo $(cat hostlist_singlenode)

EXPOSE 5432

CMD tail -f /dev/null
#CMD service ssh start && su gpadmin bash -l -c "gpstart -a --verbose" && sleep 2678400 # HACK: it's difficult to get Docker to attach to the GPDB process(es) ... so, instead attach to process "sleep for 1 month"
