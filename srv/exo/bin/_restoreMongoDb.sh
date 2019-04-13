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
display_time rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}
pushd ${BACKUP_WORKING_DIR}/tmp_mongo/ >/dev/null 2>&1

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}

echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] = restore MongoDB ${CHAT_DATABASE} from ${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

if ${BACKUP_ON_RESTORE}; then
  if [ -e "${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}.old" ]; then
    echo "[INFO] = remove previous backup save ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}.old ..."
    rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}.old
  fi

  echo "[INFO] = Backup current data on ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}.old ..."
  display_time mongodump -o ${BACKUP_WORKING_DIR}/tmp_mongo --db=${CHAT_DATABASE}
  mv -v ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE} ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}.old
fi

TARGET="${PLF_NAME}-${CHAT_DATABASE}-${BACKUP_DATE}.tar.bz2"

echo "[INFO] Uncompress mongo dump on ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}"
display_time tar xvf ${BACKUP_WORKING_DIR}/tmp_mongo/${TARGET} --use-compress-program pbzip2 -C ${BACKUP_WORKING_DIR}/tmp_mongo/

echo "[INFO]"
echo "[INFO] Restore database ${CHAT_DATABASE} from ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}"
display_time mongorestore --drop --db=${CHAT_DATABASE} ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}

echo "[INFO]"
  echo "[INFO] Remove ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE} content ..."
display_time rm -rf ${BACKUP_WORKING_DIR}/tmp_mongo/${CHAT_DATABASE}

echo "[INFO] Remove ${BACKUP_WORKING_DIR}/tmp_mongo/${TARGET} ..."
display_time rm ${BACKUP_WORKING_DIR}/tmp_mongo/${TARGET}

echo "[INFO] Done"
echo "[INFO] $(display_date)"

popd >/dev/null 2>&1
