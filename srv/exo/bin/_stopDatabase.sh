#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

echo "[INFO] ======================================="
echo "[INFO] Stopping Database server on ${HOSTNAME}..."
echo "[INFO] ======================================="

if [ -e /lib/systemd/system/mysql.service ]; then
  echo ""
  ACTION=stop  
  systemd_action ${ACTION} mysql
else
  echo "[WARN] $(display_date) Database not deployed. Cannot be stopped !!!"
fi
echo "[INFO] Done"