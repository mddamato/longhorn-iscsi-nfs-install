FROM centos:7 as builder0

RUN yum install -y pigz yum-utils createrepo unzip epel-release && \
    mkdir lh-rpm-el7 && \
    cd lh-rpm-el7 && \
    yum install -y --releasever=/ --installroot=$(pwd) --downloadonly --downloaddir $(pwd) nfs-utils iscsi-initiator-utils && \
    createrepo -v . && \
    cd ..

FROM centos:8 as builder1

RUN dnf install -y epel-release yum-utils createrepo && \
    curl -LO http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/modulemd-tools-0.7-4.el8.noarch.rpm && \
    dnf install -y ./modulemd-tools-0.7-4.el8.noarch.rpm && \
    rm -f modulemd-tools-0.7-4.el8.noarch.rpm && \
    mkdir -p lh-rpm-el8/Packages && \
    cd lh-rpm-el8/Packages && \
    yum install -y --releasever=/ --installroot=$(pwd) --downloadonly --downloaddir $(pwd) nfs-utils iscsi-initiator-utils && \
    cd .. && \
    createrepo_c . && \
    repo2module  -s stable -d . modules.yaml && \
    modifyrepo_c --mdtype=modules ./modules.yaml ./repodata && \
    cd ..

FROM alpine:3.12

COPY --from=builder0 /lh-rpm-el7 /longhorn-iscsi-nfs-install/lh-rpm-el7
COPY --from=builder1 /lh-rpm-el8 /longhorn-iscsi-nfs-install/lh-rpm-el8
COPY --chmod=0777 entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD ["/entrypoint.sh"]