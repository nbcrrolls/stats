#!/bin/bash

# bring opal stats logs from rocce-vm3

HOST=rocce-vm3
FQDN=rocce-vm3.ucsd.edu
BASE=/root/opal-stats
YEAR=`date +%Y`


cd $BASE

if [ ! -d $BASE/$YEAR ]; then
    mkdir -p $BASE/$YEAR
fi

if [ ! -d $BASE/$HOST ]; then
    mkdir -p $BASE/$HOST
fi

cd $HOST
scp root@$FQDN:/root/opal-stats/$HOST-$YEAR.tar.gz .
tar xzf $HOST-$YEAR.tar.gz 

# mail log file
MSG=/tmp/meme-message
TO=nadya@sdsc.edu
ADDR=`rocks list host attr localhost | grep opal_public_fqdn | awk '{print $3}'`
echo "Collect opal stats from rocce-vm3, run on `date +%Y-%m-%d ` " > $MSG
mailx -r root@$ADDR -s "scp opal stats from $HOST" $TO < $MSG
rm -rf $MSG 

