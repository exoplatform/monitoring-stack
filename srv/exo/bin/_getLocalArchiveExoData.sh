#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPT_START_TIME=$(date +%s)

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

if [ $# -lt 1 ]; then
  echo ""
  echo "[ERROR] Need backup date to proceede to the restore !"
  exit 1
fi

BACKUP_DATE=$1

rsync -av ${EXO_BCK_DIR}/srv-exo-${BACKUP_DATE}.tar.bz2 ${EXO_BCK_TEMP_DIR}/tmp_data/