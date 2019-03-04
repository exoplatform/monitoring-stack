
#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load env settings
source ${SCRIPT_DIR}/_setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh


echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Stop ${PLF_NAME} (leader:${HOSTNAME})..."
echo "[INFO] ======================================="

ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_stopPLF.sh
ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_stopElasticSearch.sh
#ssh ${COMMUNITY_MYSQL_SERVER} ${SCRIPT_DIR}/_stopDatabase.sh

echo "[INFO] $(display_date) Done"
