FROM ypcs/debian:stretch

RUN sed -i 's/main$/main contrib non-free/g' /etc/apt/sources.list

RUN /usr/lib/docker-helpers/apt-setup && \
    /usr/lib/docker-helpers/apt-upgrade && \
    apt-get --assume-yes install \
        binutils \
        curl \
        libcap2 \
        jsvc \
        mongodb-server \
        openjdk-8-jre-headless \
        procps && \
    /usr/lib/docker-helpers/apt-cleanup

ADD https://dl.ui.com/unifi/5.11.47/unifi_sysvinit_all.deb /tmp/unifi.deb

RUN dpkg --install /tmp/unifi.deb ; \
    apt-get -f install -y && \
    rm -f /tmp/unifi.deb

RUN adduser --system --group --gecos "unifi controller,,," unifi && \
    mkdir -p /var/lib/unifi && \
    chown -R unifi:unifi /var/lib/unifi

USER unifi

ENTRYPOINT ["java", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar", "com.ubnt.ace.Launcher"]

CMD ["start"]
