#!/bin/sh

set -ex

rm -rf /mount/*

dist_version=$(nsenter --mount=/proc/1/ns/mnt -- bash -c ". /etc/os-release && echo \"\$VERSION_ID\"")
os_maj_ver=$(echo "$dist_version" | sed -E -e "s/^([0-9]+)\.?[0-9]*$/\1/")

cp -R /longhorn-iscsi-nfs-install/lh-rpm-el${os_maj_ver} /mount

echo "[longhorn-iscsi-nfs-install]" > /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo && \
echo "name=longhorn-iscsi-nfs-install" >> /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo && \
echo "baseurl=file:///var/lib/rancher/hostMount/longhorn-iscsi-nfs-install/lh-rpm-el${os_maj_ver}" >> /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo && \
echo "enabled=0" >> /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo && \
echo "gpgcheck=0" >> /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo

nsenter --mount=/proc/1/ns/mnt -- bash -c "sudo yum makecache -q -y 2>&1"
nsenter --mount=/proc/1/ns/mnt -- bash -c "sudo yum --setopt=tsflags=noscripts install --disablerepo=* --enablerepo=\"longhorn-iscsi-nfs-install\" -q -y nfs-utils iscsi-initiator-utils 2>&1"
nsenter --mount=/proc/1/ns/mnt -- bash -c "sudo systemctl -q enable iscsid 2>&1"
nsenter --mount=/proc/1/ns/mnt -- bash -c "sudo systemctl start iscsid 2>&1"

rm -rf /mount/*
rm -f /etc/yum.repos.d/longhorn-iscsi-nfs-install.repo



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