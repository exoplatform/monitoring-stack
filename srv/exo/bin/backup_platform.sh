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

SSH_COMMAND="$(getSSHCommand ${EXO_PLF_SERVER} ${EXO_USER})"

# Stop it
${SSH_COMMAND} ${SCRIPT_DIR}/_stopeXo.sh

# Dump data
${SSH_COMMAND} ${SCRIPT_DIR}/_dumpData.sh ${BACKUP_DATE}

# Dump database
${SSH_COMMAND} ${SCRIPT_DIR}/_dumpMysqlDatabase.sh ${BACKUP_DATE}

# Dump MongoDB
${SSH_COMMAND} ${SCRIPT_DIR}/_dumpMongoDb.sh ${BACKUP_DATE}

# Dump Elastic
${SSH_COMMAND} ${SCRIPT_DIR}/_stopElasticsearch.sh
${SSH_COMMAND} ${SCRIPT_DIR}/_dumpElasticsearch.sh ${BACKUP_DATE}
${SSH_COMMAND} ${SCRIPT_DIR}/_startElasticsearch.sh

# Start it
${SSH_COMMAND} ${SCRIPT_DIR}/_starteXo.sh

# Warmup the server
${SSH_COMMAND} ${SCRIPT_DIR}/warmup.sh

DOWNTIME_END_TIME=$(date +%s)
if [ "${REMOTE_BACKUP}" == true ]; then
  rsync -av ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_WORKING_DIR}/tmp_data/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_WORKING_DIR}/tmp_db/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_WORKING_DIR}/tmp_mongo/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_WORKING_DIR}/tmp_elasticsearch/* ${BACKUP_DIR}
else
  rsync -av ${BACKUP_WORKING_DIR}/tmp_data/* ${BACKUP_DIR}
  rsync -av ${BACKUP_WORKING_DIR}/tmp_db/* ${BACKUP_DIR}
  rsync -av ${BACKUP_WORKING_DIR}/tmp_mongo/* ${BACKUP_DIR}
  rsync -av ${BACKUP_WORKING_DIR}/tmp_elasticsearch/* ${BACKUP_DIR}
fi

${SCRIPT_DIR}/_cleanBackups.sh

SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended - $(date)"
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="
