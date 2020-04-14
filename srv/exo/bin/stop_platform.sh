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

SSH_COMMAND="$(getSSHCommand ${EXO_PLF_SERVER} ${EXO_USER})"

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Stop ${PLF_NAME} (leader:${HOSTNAME})..."
echo "[INFO] ======================================="

${SSH_COMMAND} ${SCRIPT_DIR}/_stopeXo.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_stopElasticsearch.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_stopDatabase.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_stopMongo.sh

echo "[INFO] $(display_date) Done"
