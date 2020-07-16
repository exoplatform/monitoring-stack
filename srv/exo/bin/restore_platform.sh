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

if [ $# -lt 1 ]; then
  echo ""
  echo "[ERROR] Need backup date to proceede to the restore !"
  exit 1
fi

SSH_EXO_COMMAND="$(getSSHCommand ${EXO_PLF_SERVER} ${EXO_USER})"
SSH_DB_COMMAND="$(getSSHCommand ${EXO_DB_SERVER} ${EXO_USER})"

BACKUP_DATE=$1

${SSH_DB_COMMAND} ${SCRIPT_DIR}/_getLocalArchiveDBData.sh ${BACKUP_DATE}
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_getLocalArchiveExoData.sh ${BACKUP_DATE}

DOWNTIME_START_TIME=$(date +%s)

# Stop it
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_stopeXo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopElasticsearch.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopMongo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_stopDatabase.sh
# restore exo data
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_restoreExoData.sh ${BACKUP_DATE}
# restore DB data
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_restoreDBData.sh ${BACKUP_DATE}

# Start it
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startElasticsearch.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startMongo.sh
${SSH_DB_COMMAND} ${SCRIPT_DIR}/_startDatabase.sh
${SSH_EXO_COMMAND} ${SCRIPT_DIR}/_starteXo.sh

DOWNTIME_END_TIME=$(date +%s)
SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended - $(date)"
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="
