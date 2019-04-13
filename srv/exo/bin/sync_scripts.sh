#!/bin/bash

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

sync_files() {
  local CONNECT_STRING=$1
  rsync -avP --delete --backup ${SCRIPT_DIR}/backups ${SCRIPT_DIR}/ ${CONNECT_STRING}:${SCRIPT_DIR}
}

mkdir -p backup

echo "[INFO] Copying script to eXo server..."
sync_files ${EXO_USER}@${EXO_PLF_SERVER}

echo "[INFO] Copying script to database server..."
sync_files ${EXO_USER}@${EXO_DB_SERVER}

echo "[INFO] Copying script to mongo server..."
sync_files ${EXO_USER}@${EXO_MONGO_SERVER}

echo "[INFO] Copying script to elasticsearch server..."
sync_files ${EXO_USER}@${EXO_ES_SERVER}

echo "[INFO] $(display_date) Done"
