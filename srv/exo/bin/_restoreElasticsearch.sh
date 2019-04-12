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
rm -rf ${ELASTICSEARCH_DATA_DIR}/*
pushd ${ELASTICSEARCH_DATA_DIR}/ >/dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Uncompressing ${BACKUP_WORKING_DIR}/tmp_elastic/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 into ${ELASTICSEARCH_DATA_DIR}  ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

pushd ${BACKUP_WORKING_DIR}/tmp_elastic >/dev/null 2>&1

display_time tar xvf ${BACKUP_WORKING_DIR}/tmp_elasticsearch/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 -C ${ELASTICSEARCH_DATA_DIR}

popd >/dev/null 2>&1
echo "[INFO] Done"
