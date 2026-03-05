FROM ghcr.io/netbootxyz/netbootxyz:latest

RUN rm -f /usr/local/bin/dnsmasq-wrapper.sh \
 && mkdir -p /etc/dnsmasq.d
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY dnsmasq-wrapper.sh /usr/local/bin/dnsmasq-wrapper.sh
RUN chmod +x /usr/local/bin/dnsmasq-wrapper.sh
