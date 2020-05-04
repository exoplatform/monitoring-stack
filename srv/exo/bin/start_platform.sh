#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
echo $SCRIPT_NAME
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

SSH_COMMAND="$(getSSHCommand ${EXO_PLF_SERVER} ${EXO_USER})"

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Start ${PLF_NAME} server on ${HOSTNAME} ..."
echo "[INFO] ======================================="

${SSH_COMMAND} ${SCRIPT_DIR}/_startDatabase.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_startMongo.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_startElasticsearch.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_starteXo.sh

${SSH_COMMAND} ${SCRIPT_DIR}/warmup.sh

echo "[INFO] $(display_date)"
echo "[INFO] Plateform started"
