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

echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Stop PLF on ${HOSTNAME} ..."
echo "[INFO] ======================================="

if [ -e ${PLF_SRV_DIR}/current/bin/catalina.sh -a -e /etc/systemd/system/${PLF_NAME}.service ]; then
  systemd_action stop ${PLF_NAME}
  if [ "$(pgrep -U $(id -u) soffice)" != "" ]; then
    echo "[INFO] $(display_date) soffice processes of ${USER} exist. Killing them ..."
    pgrep -U $(id -u) soffice | xargs kill -9
  fi
else
  echo "[WARN] ${PLF_NAME} not deployed. Cannot be stopped !!!"
fi