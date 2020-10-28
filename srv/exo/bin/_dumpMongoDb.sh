#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

# Initialize working directory
mkdir -p ${BACKUP_WORKING_DIR}/tmp_mongo
rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/*
pushd ${BACKUP_WORKING_DIR}/tmp_mongo/ >/dev/null 2>&1

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}

# settings : http://docs.mongodb.org/manual/single/index.html#document-tutorial/backup-databases-with-binary-database-dumps

echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] = Dumping MongoDB ${CHAT_DATABASE} into ${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

TARGET="${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2"

display_time mongodump -o ${BACKUP_WORKING_DIR}/tmp_mongo --db=${CHAT_DATABASE}

echo "[INFO] Compress mongo dump into ${BACKUP_WORKING_DIR}/tmp_mongo/${TARGET}"
display_time tar --directory ${BACKUP_WORKING_DIR}/tmp_mongo --use-compress-prog=pbzip2 -cpf ${BACKUP_WORKING_DIR}/tmp_mongo/${TARGET} ${CHAT_DATABASE}

echo "[INFO] Remove ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}"
display_time rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}

echo "[INFO] Done"
echo "[INFO] $(display_date)"

popd >/dev/null 2>&1
