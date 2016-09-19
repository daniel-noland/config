#!/bin/bash
root_trust=/etc/ssl;
private_trust=$root_trust/private;
cert_directory=$root_trust/certs;
cert=$1;
if [ -f $private_trust/$cert ]
then
   echo "File $private_trust/$cert exists.  Will not overwrite!"
   exit;
fi;
cp $cert $private_trust;
suffix=0;
h=$(openssl x509 -hash -noout -in $private_trust/$cert);
while [ -f $cert_directory/$h.$suffix ]
do
   echo "file $root_trust/$h.$suffix exists in trust root."
   suffix=$[$suffix+1];
   echo "trying $root_trust/$h.$suffix"
done
link_name=$cert_directory/$h.$suffix;
ln -s $private_trust/$cert $link_name;
echo "Certificate added to trusted root!"
