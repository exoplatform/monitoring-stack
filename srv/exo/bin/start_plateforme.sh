#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
echo $SCRIPT_NAME
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load env settings
source ${SCRIPT_DIR}/_setenv-template.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh
echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Start ${PLF_NAME} server on ${HOSTNAME} ..."
echo "[INFO] ======================================="
ssh ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_startDataBase.sh
ssh ${EXO_USER}@${EXO_MONGO_SERVER} ${SCRIPT_DIR}/_startMongo.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_startElasticSearch.sh
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_startPLF.sh
echo "[INFO] $(display_date) Done"