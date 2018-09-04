#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/apache

mkdir -p ${OUTPUT_DIR}

if [ "${OS_TYPE}" == "debian" ]; then
    APACHE_CMD="/usr/sbin/apache2"
    APACHE_CONF_DIR="/etc/apache2"
else
    echo "Unsupported OS type : ${OS_TYPE}"
    exit 1
fi

echo "Checking version..."
${APACHE_CMD} -v > ${OUTPUT_DIR}/version.txt

echo "Checking modules..."
${APACHE_CMD} -l > ${OUTPUT_DIR}/modules.txt

echo "Checking configuration..."
mkdir -p ${OUTPUT_DIR}/conf
rsync -avP ${APACHE_CONF_DIR} ${OUTPUT_DIR}/conf

echo "Checking fake requests..."
curl -s -v http://localhost  &> ${OUTPUT_DIR}/http.req
curl -s -v -k https://localhost  &> ${OUTPUT_DIR}/https.req

echo "Checking server status..."
/usr/sbin/apache2ctl status &>  ${OUTPUT_DIR}/status.out

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
