#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load env settings
source ${SCRIPT_DIR}/_setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

echo "[INFO] ======================================="
echo "[INFO] Stoping MongoDB server on ${HOSTNAME}..."
echo "[INFO] ======================================="

if [ -e /lib/systemd/system/mongod.service ]; then

  echo ""
  ACTION=stop  
  sudo systemctl ${ACTION} mongod
fi
echo "[INFO] Done"

