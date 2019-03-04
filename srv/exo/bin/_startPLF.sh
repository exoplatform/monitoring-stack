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
echo ""
echo "[INFO] ======================================="
echo "[INFO] = $(display_date) Start PLF server on ${HOSTNAME} ..."
echo "[INFO] ======================================="
if [ -e ${PLF_SRV_DIR}/current/bin/catalina.sh -a -e /etc/systemd/system/${PLF_NAME}.service ]; then

  echo ""
  ACTION=start
  set +u
  if [ -n "${EXO_DEBUG}" ]
  then
    ACTION=debug
  fi
  set -u

  sudo systemctl ${ACTION} ${PLF_NAME} 
  echo -n "[INFO] $(display_date) Waiting for logs availability ."
  while [ true ];
  do
    if [ -e "${PLF_LOG_DIR}/platform.log" ]; then    
      break
    fi
    echo -n "."
    sleep 1
  done
  echo -n " OK"
  echo ""

  # Display logs
  tail -f ${PLF_LOG_DIR}/platform.log &
  _tailPID=$!
  # Check for the end of startup
  set +e
  while [ true ];
  do
    if grep -q "Server startup in" ${PLF_LOG_DIR}/platform.log; then
      kill ${_tailPID}
      wait ${_tailPID} 2> /dev/null
      break
    fi
  done
  set -e
 
else
  echo "[WARN] $(display_date) ${PLF_NAME} not deployed. Cannot be started !!!"
fi
echo "[INFO] $(display_date) Done"
