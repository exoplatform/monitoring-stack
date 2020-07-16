#!/bin/bash -eu

####
# Copy the management scripts on all the servers
###

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
echo $SCRIPT_NAME
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh
echo ""

add_server_fingerprint() {
  local SERVER=$1

  if ! $(grep -q ${SERVER} ~/.ssh/known_hosts); then
    echo "[INFO] Add ${SERVER} server fingerprint on known_hosts file ..."
    ssh-keyscan -H ${SERVER} &>> ~/.ssh/known_hosts
  fi
}

sync_files() {
  local CONNECT_STRING=$1
  rsync -avP ${SCRIPT_DIR} ${CONNECT_STRING}:$(dirname ${SCRIPT_DIR})
}

mkdir -p backups

echo "[INFO] Copying script to eXo server..."
add_server_fingerprint ${EXO_PLF_SERVER}
sync_files ${EXO_USER}@${EXO_PLF_SERVER}

echo "[INFO] Copying script to database server..."
add_server_fingerprint ${EXO_DB_SERVER}
sync_files ${EXO_USER}@${EXO_DB_SERVER}

echo "[INFO] $(display_date) Done"