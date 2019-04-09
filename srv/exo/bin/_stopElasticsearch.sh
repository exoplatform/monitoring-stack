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
echo "[INFO] Stopping ElasticSearch server on ${HOSTNAME}..."
echo "[INFO] ======================================="

if [ -e /usr/lib/systemd/system/elasticsearch.service ]; then

  echo ""
  ACTION=stop  
  sudo systemctl ${ACTION} elasticsearch
else
  echo "[WARN] $(display_date) ElasticSearch not deployed. Cannot be stopped !!!"
fi
echo "[INFO] Done"