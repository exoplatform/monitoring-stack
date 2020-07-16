#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPT_START_TIME=$(date +%s)

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

DOWNTIME_START_TIME=$(date +%s)

BACKUP_DATE=$(date "+%Y-%m-%d-%H%M%S")

SSH_EXO_COMMAND="$(getSSHCommand ${EXO_PLF_SERVER} ${EXO_USER})"
SSH_DB_COMMAND="$(getSSHCommand ${EXO_DB_SERVER} ${EXO_USER})"

# Stop it
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_stopeXo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopElasticsearch.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopMongo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopDatabase.sh

# Dump data
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_dumpExoData.sh ${BACKUP_DATE}

# Dump database
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_dumpDBData.sh ${BACKUP_DATE}

# Start it
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startElasticsearch.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startMongo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startDatabase.sh
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_starteXo.sh


DOWNTIME_END_TIME=$(date +%s)
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_archiveExoData.sh ${BACKUP_DATE}
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_archiveDBData.sh ${BACKUP_DATE}

${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_cleanBackups.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_cleanBackups.sh

SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended - $(date)"
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="
