#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

echo "[INFO] ======================================="
echo "[INFO] Stopping Elasticsearch server on ${HOSTNAME}..."
echo "[INFO] ======================================="

systemd_action stop elasticsearch

echo "[INFO] Done"
