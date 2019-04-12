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

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Stop ${PLF_NAME} (leader:${HOSTNAME})..."
echo "[INFO] ======================================="

ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_stopeXo.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_stopElasticSearch.sh
ssh ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_stopDatabase.sh
ssh ${EXO_USER}@${EXO_MONGO_SERVER} ${SCRIPT_DIR}/_stopMongo.sh

echo "[INFO] $(display_date) Done"
