#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SCRIPT_START_TIME=$(date +%s)

# Load env settings
source ${SCRIPT_DIR}/_setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

DOWNTIME_START_TIME=$(date +%s)
# Stop it
#ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_stopPLF.sh

# Dump database
ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_dumpDatabase.sh

# Start it

#ssh -i ${SCRIPT_DIR}/id_rsa ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_startPLF.sh
DOWNTIME_END_TIME=$(date +%s)

SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended -" `date`
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="