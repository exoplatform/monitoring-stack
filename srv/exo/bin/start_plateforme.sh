#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
echo $SCRIPT_NAME
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load env settings
source ${SCRIPT_DIR}/_setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh
echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Start ${PLF_NAME} server on ${HOSTNAME} ..."
echo "[INFO] ======================================="

#ssh ${COMMUNITY_MYSQL_SERVER} ${SCRIPT_DIR}/_startDatabase.sh
ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_startElasticSearch.sh
ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_startPLF.sh

echo "[INFO] $(display_date) Done"

