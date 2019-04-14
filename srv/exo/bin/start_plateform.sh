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
echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Start ${PLF_NAME} server on ${HOSTNAME} ..."
echo "[INFO] ======================================="
ssh ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_startDatabase.sh
ssh ${EXO_USER}@${EXO_MONGO_SERVER} ${SCRIPT_DIR}/_startMongo.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_startElasticsearch.sh
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_starteXo.sh
echo "[INFO] $(display_date)"
echo "[INFO] Plateform started"
