#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# Load env settings
source ${SCRIPT_DIR}/_setenv-template.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

# Initialize working directory
mkdir -p ${BACKUP_WORKING_DIR}/tmp_mongo
rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/*
pushd ${BACKUP_WORKING_DIR}/tmp_mongo/ > /dev/null 2>&1

# settings : http://docs.mongodb.org/manual/single/index.html#document-tutorial/backup-databases-with-binary-database-dumps

echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] = Dumping MongoDB ${EXO_CHAT_MONGODB_NAME} into ${BACKUP_WORKING_DIR}/tmp_mongo ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

display_time mongodump -o ${BACKUP_WORKING_DIR}/tmp_mongo --db=${EXO_CHAT_MONGODB_NAME}
#display_time sudo chown -R exo:exo ${BACKUP_WORKING_DIR}/tmp_mongo

echo "[INFO] Done"
echo "[INFO] $(display_date)"

popd > /dev/null 2>&1