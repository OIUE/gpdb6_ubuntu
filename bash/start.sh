sleep 2
source /home/gpadmin/.bash_profile
ssh-keygen -f /home/gpadmin/.ssh/id_rsa -t rsa -N ""
echo `hostname` > hostlist_singlenode
sed -i "s/localhost/`hostname`/g" gpinitsystem_singlenode

cat gpinitsystem_singlenode
cat hostlist_singlenode

gpssh-exkeys -f hostlist_singlenode

gpinitsystem -ac gpinitsystem_singlenode
echo "host all  all 0.0.0.0/0 trust" >> /data/gpmaster/gpsne-1/pg_hba.conf
