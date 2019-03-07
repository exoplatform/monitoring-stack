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

SCRIPT_DATE=`date "+%Y-%m-%d-%H%M%S"`

# Initialize working directory
rm -rf ${PLF_BCK_DIR}/*
pushd ${PLF_BCK_DIR} > /dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Compressing ${PLF_NAME} data into ${PLF_BCK_DIR}/${PLF_NAME}-data-${SCRIPT_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"
pushd ${PLF_BCK_DIR} > /dev/null 2>&1
display_time tar --directory ${DATA_WORKING_DIR} --use-compress-prog=pbzip2 -cpf ${PLF_BCK_DIR}/${PLF_NAME}-data-${SCRIPT_DATE}.tar.bz2 data  
pushd ${PLF_BCK_DIR} > /dev/null 2>&1
popd > /dev/null 2>&1
echo "[INFO] Done"
