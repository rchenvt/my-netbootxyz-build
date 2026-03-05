#!/bin/bash

# 1. Get IP from route if not in env
if [ -z "${CONTAINER_IP}" ]; then
    CONTAINER_IP=$(ip route get to 1.1.1.1 | awk '/1.1.1.1/ { print $7}')
fi

# 2. Derive Subnet (Assumes /24)
if [ -z "${DHCP_RANGE_START}" ]; then
    DHCP_RANGE_START="${CONTAINER_IP%.*}.0"
fi

# 3. Exec Dnsmasq
# We use "$@" here so that %(ENV_TFTPD_OPTS)s from supervisor still gets passed through
exec /usr/sbin/dnsmasq -C /etc/dnsmasq.conf \
    --dhcp-range=${DHCP_RANGE_START},proxy \
    --dhcp-boot=tag:ipxe-bios,netboot.xyz.kpxe,,${CONTAINER_IP} \
    --dhcp-boot=tag:ipxe-efi,netboot.xyz.efi,,${CONTAINER_IP} \
    --dhcp-option=tag:ipxe-bios,54,${CONTAINER_IP} \
    --dhcp-option=tag:ipxe-efi,54,${CONTAINER_IP} \
    "$@"
