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

echo "[INFO] ======================================="
echo "[INFO] Restoring Elasticsearch data"
echo "[INFO] ======================================="

pushd ${BACKUP_WORKING_DIR}/tmp_elasticsearch >/dev/null 2>&1

if ${BACKUP_ON_RESTORE} && [ -e "${ELASTICSEARCH_DATA_DIR}/nodes.old" ]; then
  echo "[INFO] Removing previous backup save directory (${ELASTICSEARCH_DATA_DIR}/nodes.old)..."
  sudo -u elasticsearch rm -rf ${ELASTICSEARCH_DATA_DIR}/nodes.old
fi

if ${BACKUP_ON_RESTORE} && [ -e "${ELASTICSEARCH_DATA_DIR}/nodes" ]; then
  echo "[INFO] Keeping current data in (${ELASTICSEARCH_DATA_DIR}/nodes.old) directory ..."
  sudo -u elasticsearch mv -f ${ELASTICSEARCH_DATA_DIR}/nodes ${ELASTICSEARCH_DATA_DIR}/nodes.old
else 
  echo "[INFO] Removing current data on (${ELASTICSEARCH_DATA_DIR}/nodes) directory ..."
  sudo -u elasticsearch rm -rf ${ELASTICSEARCH_DATA_DIR}/nodes ${ELASTICSEARCH_DATA_DIR}/nodes
fi

echo "[INFO] = Uncompressing ${BACKUP_WORKING_DIR}/tmp_elasticsearch/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 into ${ELASTICSEARCH_DATA_DIR}  ..."
echo "[INFO] $(display_date)"
display_time sudo -u elasticsearch tar xf ${BACKUP_WORKING_DIR}/tmp_elasticsearch/${PLF_NAME}-es-${BACKUP_DATE}.tar.bz2 -C ${ELASTICSEARCH_DATA_DIR}/..

popd >/dev/null 2>&1
echo "[INFO] Done"
