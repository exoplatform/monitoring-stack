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

DUMP_OPTIONS="--single-transaction"

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}

TARGET_NAME="${PLF_NAME}-db-${BACKUP_DATE}.sql.bz2"

echo "[INFO] ======================================="
echo "[INFO] = restoring database ${EXO_DATABASE} into ${BACKUP_WORKING_DIR}/tmp_db/${TARGET_NAME} ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

if ${BACKUP_ON_RESTORE}; then
  BACKUP_FILE="${BACKUP_WORKING_DIR}/tmp_db/mysql-old.sql.bz2"
  echo "[INFO] Save current database in ${BACKUP_FILE}"
  
  DUMP_OPTIONS="--single-transaction --add-drop-table"

  display_time sudo mysqldump ${DUMP_OPTIONS} ${EXO_DATABASE} | pbzip2 >${BACKUP_FILE}
 
  echo "[INFO] $(display_date)"
fi

display_time pbzip2 -d -c ${BACKUP_WORKING_DIR}/tmp_db/${TARGET_NAME} | mysql ${EXO_DATABASE}

echo "[INFO] Clean ${BACKUP_WORKING_DIR}/tmp_db/ content"
display_time rm -rf ${BACKUP_WORKING_DIR}/tmp_db/${TARGET_NAME}

echo "[INFO] $(display_date)"
echo "[INFO] Done"

popd >/dev/null 2>&1
