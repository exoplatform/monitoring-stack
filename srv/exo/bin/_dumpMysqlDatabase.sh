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

DUMP_OPTIONS="--single-transaction --add-drop-table"

# Initialize working directory
mkdir -p ${BACKUP_WORKING_DIR}/tmp_db
rm -rf ${BACKUP_WORKING_DIR}/tmp_db/*
pushd ${BACKUP_WORKING_DIR}/tmp_db >/dev/null 2>&1

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}

TARGET_NAME="${PLF_NAME}-db-${BACKUP_DATE}.sql.bz2"

echo "[INFO] ======================================="
echo "[INFO] = Dumping database ${EXO_DATABASE} into ${BACKUP_WORKING_DIR}/tmp_db/${TARGET_NAME} ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

display_time mysqldump ${DUMP_OPTIONS} ${EXO_DATABASE} | pbzip2 >${BACKUP_WORKING_DIR}/tmp_db/${TARGET_NAME}

echo "[INFO] Done"

popd >/dev/null 2>&1
