FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
    apt-get install -y --no-install-recommends --force-yes \
    locales tinyproxy && \
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN sed -i -e"s/^Allow /#Allow /" /etc/tinyproxy/tinyproxy.conf
RUN [ -d /var/run/tinyproxy ] || mkdir -p /var/run/tinyproxy ; chown nobody. /var/run/tinyproxy
USER nobody

EXPOSE 8888
ENTRYPOINT ["/usr/sbin/tinyproxy", "-d"]
