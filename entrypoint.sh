#!/bin/sh

set -e

sudo yum makecache -q -y;
sudo yum --setopt=tsflags=noscripts install -q -y --repofrompath lh,lh-rpm-el8 iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi;
sudo systemctl -q enable iscsid;
sudo systemctl start iscsid; 


# OS=$(grep "ID_LIKE" /etc/os-release | cut -d '=' -f 2); 
# if [[ "${OS}" == *"debian"* ]]; then 
#     sudo apt-get update -q -y && sudo apt-get install -q -y open-iscsi && sudo systemctl -q enable iscsid && sudo systemctl start iscsid; 

# elif [[ "${OS}" == *"suse"* ]]; then 
#     sudo zypper --gpg-auto-import-keys -q refresh && sudo zypper --gpg-auto-import-keys -q install -y open-iscsi && sudo systemctl -q enable iscsid && sudo systemctl start iscsid; 

# else 
#     sudo yum makecache -q -y && \
#     sudo yum --setopt=tsflags=noscripts install -q -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && \
#     sudo systemctl -q enable iscsid && \
#     sudo systemctl start iscsid; 

# fi && if [ $? -eq 0 ]; 
# then echo "iscsi install successfully"; 
# else echo "iscsi install failed error code $?"; 
# fi