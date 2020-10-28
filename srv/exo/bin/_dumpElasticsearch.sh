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
mkdir -p ${BACKUP_WORKING_DIR}/tmp_elasticsearch
rm -rf ${BACKUP_WORKING_DIR}/tmp_elasticsearch/*
pushd ${BACKUP_WORKING_DIR}/tmp_elasticsearch >/dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Compressing ${PLF_NAME} data into ${BACKUP_WORKING_DIR}/tmp_elasticsearch/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

pushd ${BACKUP_WORKING_DIR}/tmp_elasticsearch >/dev/null 2>&1

display_time tar --directory $(dirname ${ELASTICSEARCH_DATA_DIR}) --use-compress-prog=pbzip2 -cpf ${BACKUP_WORKING_DIR}/tmp_elasticsearch/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 $(basename ${ELASTICSEARCH_DATA_DIR})

popd >/dev/null 2>&1
echo "[INFO] Done"
