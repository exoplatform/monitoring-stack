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
mkdir -p ${BACKUP_WORKING_DIR}/tmp_data
rm -rf ${BACKUP_WORKING_DIR}/tmp_data/*
pushd ${BACKUP_WORKING_DIR}/tmp_data >/dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Compressing ${PLF_NAME} data into ${BACKUP_WORKING_DIR}/tmp_data/${PLF_NAME}-data-${BACKUP_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

pushd ${BACKUP_WORKING_DIR}/tmp_data >/dev/null 2>&1

display_time tar --directory ${EXO_DATA_DIR} --use-compress-prog=pbzip2 -cpf ${BACKUP_WORKING_DIR}/tmp_data/${PLF_NAME}-data-${BACKUP_DATE}.tar.bz2 data

popd >/dev/null 2>&1
echo "[INFO] Done"
