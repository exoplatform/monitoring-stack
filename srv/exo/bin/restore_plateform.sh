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

BACKUP_DATE=$1

if [ ${DOWNLOAD_BACKUP} ]; then
  rsync -av ${BACKUP_DIR}/${PLF_NAME}-data-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_WORKING_DIR}/tmp_data/
  rsync -av ${BACKUP_DIR}/${PLF_NAME}-db-${BACKUP_DATE}.sql.bz2 ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_WORKING_DIR}/tmp_db/
  rsync -av ${BACKUP_DIR}/${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_WORKING_DIR}/tmp_mongo/
  rsync -av ${BACKUP_DIR}/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_WORKING_DIR}/tmp_elasticsearch/ 
else
  rsync -av ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_DIR}/${PLF_NAME}-data-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_PLF_SERVER}:${BACKUP_WORKING_DIR}/tmp_data/ 
  rsync -av ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_DIR}/${PLF_NAME}-db-${BACKUP_DATE}.sql.bz2 ${EXO_USER}@${EXO_DB_SERVER}:${BACKUP_WORKING_DIR}/tmp_db/
  rsync -av ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_DIR}/${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_MONGO_SERVER}:${BACKUP_WORKING_DIR}/tmp_mongo/
  rsync -av ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_DIR}/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 ${EXO_USER}@${EXO_ES_SERVER}:${BACKUP_WORKING_DIR}/tmp_elasticsearch/
fi

DOWNTIME_START_TIME=$(date +%s)

# Stop it
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_stopeXo.sh

# restore data
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_restoreData.sh ${BACKUP_DATE}

# Dump database
ssh ${EXO_USER}@${EXO_DB_SERVER} ${SCRIPT_DIR}/_restoreMysqlDatabase.sh ${BACKUP_DATE}

# Dump MongoDB
ssh ${EXO_USER}@${EXO_MONGO_SERVER} ${SCRIPT_DIR}/_restoreMongoDb.sh ${BACKUP_DATE}

# Dump Elastic
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_stopElasticsearch.sh
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_restoreElasticsearch.sh ${BACKUP_DATE}
ssh ${EXO_USER}@${EXO_ES_SERVER} ${SCRIPT_DIR}/_startElasticsearch.sh

# Start it
ssh ${EXO_USER}@${EXO_PLF_SERVER} ${SCRIPT_DIR}/_starteXo.sh

DOWNTIME_END_TIME=$(date +%s)
SCRIPT_END_TIME=$(date +%s)

echo "[INFO] ======================================="
echo "[INFO] = Backup ended -" $(date)
echo "[INFO] =--------------------------------------"
display_delay "= -> Process duration" $SCRIPT_START_TIME $SCRIPT_END_TIME
echo "[INFO] =--------------------------------------"
display_delay "= -> Service downtime" $DOWNTIME_START_TIME $DOWNTIME_END_TIME
echo "[INFO] ======================================="
