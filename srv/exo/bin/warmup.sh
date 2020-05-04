#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -o pipefail

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Starting server warmup ..."
echo "[INFO] ======================================="

set +ue
if [ "${WARMUP_ACTIVATED}" != "true" ]; then
    echo "[INFO] Warmup script is disabled"
    exit 0
fi
set -ue

## Test if curl is installed
set +e
CURL_CMD=$(which curl)
RET=$?
set -e

if [ $RET -ne 0 ]; then
  echo "[ERROR] curl command is not installed on the system"
  exit 1
fi

COOKIE_TEMP=$(tempfile -m 600 -d /tmp -p warmup)
ASSET_LIST=$(tempfile -m 600 -d /tmp -p warmupassets)

trap "rm -fv ${COOKIE_TEMP} ${ASSET_LIST}" EXIT

echo "[INFO] = $(display_date) Login into ${WARMUP_URL} with user ${WARMUP_USER} ..."

set +e
curl -s -L -c ${COOKIE_TEMP} -b ${COOKIE_TEMP}  -XPOST -d "username=${WARMUP_USER}&password=${WARMUP_PASSWORD}" --post302 ${WARMUP_URL} | grep -E -o -e "=[ \"']+/[.a-zA-Z0-9\/-]+\.css[\"']{1}" -e "=[ \"']+/[.a-zA-Z0-9\/-]+\.js[\"']{1}" | tr -d " " | tr -d "\"" | tr -d "=" > ${ASSET_LIST}
RET=$?
set -e

if [ $RET -ne 0 ]; then
  echo "[ERROR] Login failed"
  exit 1
fi

echo "[INFO] = $(display_date) Login done ..."
echo "[INFO] = $(display_date) $(cat ${ASSET_LIST} | wc -l) assets found ..."
cat ${ASSET_LIST}
echo "[INFO] = $(display_date) Loading them ..."

set +e
for i in $(cat ${ASSET_LIST}); do
    ${CURL_CMD} -s -L -c /tmp/cookies -b /tmp/cookies ${WARMUP_URL}$i > /dev/null
done
set -e

echo "[INFO] = $(display_date) All assets called ..."

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Warmup done ..."
echo "[INFO] ======================================="
