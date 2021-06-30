#!/bin/sh
#
# This is a Shell script for ArozOS with Docker image
# 
# Copyright (C) 2024 5points
#
# Thanks: Teddysun
#
# Reference URL:
# https://github.com/tobychui/arozos


PLATFORM=$(arch)
if [ -z "$PLATFORM" ]; then
    ARCH="linux_amd64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="linux_386"
            ;;
        linux/amd64|x86_64)
            ARCH="linux_amd64"
            ;;
        linux/arm/v6)
            ARCH=""
            ;;
        linux/arm/v7)
            ARCH=""
            ;;
        linux/arm/v8|aarch64)
            ARCH="linux_arm64"
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
# Download binary file
AROZOS_VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/tobychui/arozos/releases/latest | grep 'tag_name' | cut -d\" -f 4)
[ -z "${AROZOS_VERSION}" ] && echo "Error: Get arozos latest version failed" && exit 1
AROZOS_FILE="arozos_${ARCH}"
AROZOS_DL_FILE="https://github.com/tobychui/arozos/releases/download/${AROZOS_VERSION}/${AROZOS_FILE}"

# Download launcher file
LAUNCHER_VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/aroz-online/launcher/releases/latest | grep 'tag_name' | cut -d\" -f 4)
[ -z "${LAUNCHER_VERSION}" ] && echo "Error: Get arozos_launcher latest version failed" && exit 1
LAUNCHER_FILE="launcher_${ARCH}"
LAUNCHER_DL_FILE="https://github.com/aroz-online/launcher/releases/download/${LAUNCHER_VERSION}/${LAUNCHER_FILE}"

# Download web tarfile
WEBFILE_VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/tobychui/arozos/releases/latest | grep 'tag_name' | cut -d\" -f 4)
[ -z "${WEBFILE_VERSION}" ] && echo "Error: Get arozos_launcher latest version failed" && exit 1
WEBFILE_FILE="web.tar.gz"
WEBFILE_DL_FILE="https://github.com/tobychui/arozos/releases/download/${WEBFILE_VERSION}/${WEBFILE_FILE}"

echo "Downloading binary file: ${AROZOS_FILE}"
#wget -O ${AROZOS_FILE} ${AROZOS_DL_FILE} > /dev/null 2>&1
curl -skSL -o "arozos" ${AROZOS_DL_FILE} > /dev/null 2>&1
# Check if the downloaded file is complete
if [ ! -s "arozos" ]; then
    echo "Error: Failed to download binary file: ${AROZOS_FILE}" && exit 1
fi
chmod 744 arozos

echo "Downloading launcher file: ${LAUNCHER_FILE}"
curl -skSL -o "launcher" ${LAUNCHER_DL_FILE} > /dev/null 2>&1
# Check if the downloaded file is complete
if [ ! -s "launcher" ]; then
    echo "Error: Failed to download launcher file: ${LAUNCHER_FILE}" && exit 1
fi
chmod 744 launcher

echo "Downloading tarfile: ${WEBFILE_FILE}"
curl -skSL -o ${WEBFILE_FILE} ${WEBFILE_DL_FILE} > /dev/null 2>&1
# Check if the downloaded file is complete
if [ ! -s "${WEBFILE_FILE}" ]; then
    echo "Error: Failed to download tarfile: ${WEBFILE_FILE}" && exit 1
fi
chmod 644 ${WEBFILE_FILE}
#tar -xzvf ${WEBFILE_FILE}
# rm -vf ${WEBFILE_FILE}

echo '#!/bin/bash' > check-start.sh
echo '' >> check-start.sh
echo 'check_web() {' >> check-start.sh
echo '    echo "Checking if the '"'"'web'"'"' folder is empty..."' >> check-start.sh
echo '' >> check-start.sh
echo '    if [ -z "$(ls -A /arozos/web)" ]; then' >> check-start.sh
echo '        echo '"'"'web'"'"' folder is empty. Extracting files from '"'"'web.tar.gz'"'"'..."' >> check-start.sh
echo '        tar -xzvf web.tar.gz -C /arozos/' >> check-start.sh
echo '    else' >> check-start.sh
echo '        echo '"'"'web'"'"' folder is not empty."' >> check-start.sh
echo '    fi' >> check-start.sh
echo '}' >> check-start.sh
echo '' >> check-start.sh
echo '# Call the extra function' >> check-start.sh
echo 'check_web' >> check-start.sh
echo 'exit 0' >> check-start.sh
