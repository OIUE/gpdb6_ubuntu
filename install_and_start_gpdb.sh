#!/bin/bash
sleep 5

echo "==== REMOVE OLD ID_RSA KEYS"
rm /home/gpadmin/.ssh/id_rsa
rm /home/gpadmin/.ssh/id_rsa.pub

echo "==== SSH START"
# /etc/init.d/ssh start

echo "==== SSH KEYGEN"
ssh-keygen -f /home/gpadmin/.ssh/id_rsa -t rsa -N ""

echo "==== SOURCE PROFILE"
source /home/gpadmin/.bash_profile

echo "==== PREPARE FOLDERS AND CONFIGS"

cp $GPHOME/docs/cli_help/gpconfigs/gpinitsystem_singlenode /data/gpinitsystem_singlenode
sed -i 's/gpdata1/data\/data1/g' /data/gpinitsystem_singlenode
sed -i 's/gpdata2/data\/data2/g' /data/gpinitsystem_singlenode
sed -i 's/gpmaster/data\/master/g' /data/gpinitsystem_singlenode

echo "==== HOSTNAME TO SINGLENODE"
echo `hostname` > /data/hostlist_singlenode
sed -i 's/hostname_of_machine/`hostname`/g' /data/gpinitsystem_singlenode

echo "==== VALIDATE VIA GPSSH-EXKEYS"
gpssh-exkeys -f /data/hostlist_singlenode

pushd /data
  echo "==== GPINITSYSTEM"
  gpinitsystem -ac gpinitsystem_singlenode

  echo "==== host all all 0.0.0.0/0 trust"
  echo "host all  all 0.0.0.0/0 trust" >> /data/master/gpsne-1/pg_hba.conf

  echo "==== RESTARTER"
  MASTER_DATA_DIRECTORY=/data/master/gpsne-1 gpstop -a
  MASTER_DATA_DIRECTORY=/data/master/gpsne-1 gpstart -a
popd

echo "==== DONE!"
