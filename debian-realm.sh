#!/bin/sh
#
# This is a Shell script for shadowsocks-rust based debian with Docker image
# 
# Copyright (C) 2023 5points
#
# Thanks: Teddysun
#
# Reference URL:
# https://github.com/zhboner/realm

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="x86_64-unknown-linux-gnu"
else
    case "$PLATFORM" in
        linux/386)
            ARCH=""
            ;;
        linux/amd64)
            ARCH="x86_64-unknown-linux-gnu"
            ;;
        linux/arm/v6)
            ARCH="arm-unknown-linux-musleabi"
            ;;
        linux/arm/v7)
            ARCH="armv7-unknown-linux-musleabihf"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="aarch64-unknown-linux-gnu"
            ;;
        linux/ppc64le)
            ARCH=""
            ;;
        linux/s390x)
            ARCH=""
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
REALM_VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/zhboner/realm/releases/latest | grep 'tag_name' | cut -d\" -f 4)
[ -z "${REALM_VERSION}" ] && echo "Error: Get realm latest version failed" && exit 1
# Download binary file
REALM_FILE="realm-${ARCH}.tar.gz"
REALM_DL_FILE="https://github.com/zhboner/realm/releases/download/${REALM_VERSION}/{REALM_FILE}"
echo "Downloading shadowsocks-rust binary file: ${SHADOWSOCKS_RUST_FILE}"
wget -O ${REALM_FILE} ${REALM_DL_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download realm binary file: ${REALM_FILE}" && exit 1
fi
echo "Download realm binary file: ${REALM_FILE} completed"
echo "Extracting ${SHADOWSOCKS_RUST_FILE}..."
tar -zxvf ${REALM_FILE} -C /usr/bin
chmod +x /usr/bin/realm
rm -vf ${REALM_FILE}
echo "Install realm binary file: ${REALM_FILE} completed"
