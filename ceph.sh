#!/bin/bash

NODES="ceph01 ceph02 ceph03"

NodesArray=(${NODES})

# get length of an array
SIZE=${#NodesArray[@]}

sudo apt-get -y install ceph-deploy ceph-common ceph-mds
mkdir ceph
cd ceph 

# configure cluster
ceph-deploy new $NODES
# install Ceph on all Nodes
ceph-deploy install $NODES

# initial configuration for monitoring and keys
ceph-deploy mon create-initial 


# prepare Object Storage Daemon
STORAGE="${NodesArray[0]}:/storage01"

  for (( i=1; i<$SIZE; i++ ));
     do
      STORAGE="$STORAGE ${NodesArray[$i]}:/storage0$((i+1))"
   done


ceph-deploy osd prepare $STORAGE
# activate Object Storage Daemon
ceph-deploy osd activate $STORAGE
# Configure Meta Data Server
ceph-deploy admin ceph-mds 
#ceph-deploy mds create ceph-mds 
show status
#ceph mds stat 
ceph health 

