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

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}

# Initialize working directory
pushd ${EXO_DATA_DIR} >/dev/null 2>&1

ARCHIVE="${BACKUP_WORKING_DIR}/tmp_data/${PLF_NAME}-data-${BACKUP_DATE}.tar.bz2"

echo "[INFO] ======================================="
echo "[INFO] Restoring data from ${ARCHIVE}"
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

if ${BACKUP_ON_RESTORE}; then
  echo "[INFO] Saving current data ..."

  if [ -e ${EXO_DATA_DIR}/data.beforerestore ]; then
    mv -v ${EXO_DATA_DIR}/data.beforerestore ${EXO_DATA_DIR}/data.beforerestore-old
    # Can be long process in background
    rm -rf ${EXO_DATA_DIR}/data.beforerestore-old &
  fi

  if [ -e ${EXO_DATA_DIR}/data ]; then
    mv -v ${EXO_DATA_DIR}/data ${EXO_DATA_DIR}/data.beforerestore
  fi
else
  echo "[INFO] Removing current data ..."
  if [ -e ${EXO_DATA_DIR}/data ]; then
    mv -v ${EXO_DATA_DIR}/data ${EXO_DATA_DIR}/data.beforerestore
    # Can be long process in background
    rm -rf ${EXO_DATA_DIR}/data.beforerestore &
  fi
fi

pushd ${BACKUP_WORKING_DIR}/tmp_data >/dev/null 2>&1

echo "[INFO] = Uncompressing ${ARCHIVE} into ${EXO_DATA_DIR} ..."
display_time tar xf ${ARCHIVE} -C ${EXO_DATA_DIR}
echo "[INFO] $(display_date)"
echo "[INFO] Done"

rm -v ${ARCHIVE}

echo "[INFO] = waiting for cleanup to end ..."
# be sure all the cleanup processes are finished
wait 

popd >/dev/null 2>&1
echo "[INFO] Done"
