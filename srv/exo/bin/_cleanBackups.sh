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


echo "[INFO] ======================================="
echo "[INFO] = Remove old backups and keep only the ${BACKUP_RETENTION} newest ones ..."
echo "[INFO] ======================================="

pushd ${BACKUP_DIR} &>/dev/null

NB_FILES_PER_BACKUP=4

LINES=$((BACKUP_RETENTION * NB_FILES_PER_BACKUP + 1 ))
rm -rvf $(find . -maxdepth 1 -type f | xargs ls -t | tail -n +${LINES})

echo "[INFO] Done"
popd &>/dev/null
