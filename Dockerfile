FROM centos:7

COPY zerotier-installer.sh /zerotier-installer.sh
COPY zerotier-join.sh /zerotier-join.sh
COPY zerotier-leave.sh /zerotier-leave.sh

ENTRYPOINT ["sleep", "infinity"]
