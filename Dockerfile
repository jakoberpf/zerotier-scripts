FROM debian:bookworm
LABEL maintainer="github@jakoberpf.de"

ARG VERSION=1.10.6

RUN apt-get update -qq && apt-get install curl gpg -y
RUN mkdir -p /usr/share/zerotier && \
    curl -o /usr/share/zerotier/tmp.asc "https://download.zerotier.com/contact%40zerotier.com.gpg" && \
    gpg --no-default-keyring --keyring /usr/share/zerotier/zerotier.gpg --import /usr/share/zerotier/tmp.asc && \
    rm -f /usr/share/zerotier/tmp.asc && \
    echo "deb [signed-by=/usr/share/zerotier/zerotier.gpg] http://download.zerotier.com/debian/bullseye bullseye main" > /etc/apt/sources.list.d/zerotier.list

RUN apt-get update -qq && apt-get install zerotier-one=${VERSION} curl iproute2 net-tools iputils-ping openssl libssl1.1 -y
RUN rm -rf /var/lib/zerotier-one

COPY zerotier-join.sh /join.sh
COPY zerotier-leave.sh /leave.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

HEALTHCHECK --interval=1s CMD bash /healthcheck.sh

CMD []
ENTRYPOINT ["/entrypoint.sh"]