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
# Stop it
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_stopPLF.sh

# Dump data
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_dumpData.sh

# Dump database
ssh ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_dumpMysqlDatabase.sh

# Dump MongoDB
ssh ${EXO_USER}@${EXO_MONGO_SERVER} ${SCRIPT_DIR}/_dumpMongoDb.sh

# Dump Elastic
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_stopElasticsearch.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_dumpElasticsearch.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_startElasticsearch.sh

# Start it
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_startPLF.sh

DOWNTIME_END_TIME=$(date +%s)
if [ ${DOWNLOAD_BACKUP} ]; then
  rsync -av ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_WORKING_DIR}/tmp_data/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_WORKING_DIR}/tmp_db/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_WORKING_DIR}/tmp_mongo/* ${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_WORKING_DIR}/tmp_elasticsearch/* ${BACKUP_DIR}
else
  rsync -av ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_WORKING_DIR}/tmp_data/* ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_WORKING_DIR}/tmp_db/* ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_WORKING_DIR}/tmp_mongo/* ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_DIR}
  rsync -av ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_WORKING_DIR}/tmp_elasticsearch/* ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_DIR}
fi

SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended -" $(date)
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="
