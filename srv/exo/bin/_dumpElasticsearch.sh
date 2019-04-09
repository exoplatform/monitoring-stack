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

SCRIPT_DATE=`date "+%Y-%m-%d-%H%M%S"`

# Initialize working directory
mkdir -p ${BACKUP_WORKING_DIR}/tmp_elastic
rm -rf ${BACKUP_WORKING_DIR}/tmp_elastic/*
pushd ${BACKUP_WORKING_DIR}/tmp_elastic > /dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Compressing ${PLF_NAME} data into ${BACKUP_WORKING_DIR}/tmp_elastic/${PLF_NAME}-ES-${SCRIPT_DATE}.tar.bz2 ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"
pushd ${BACKUP_WORKING_DIR}/tmp_elastic > /dev/null 2>&1
display_time tar --directory ${ELASTIC_WORKING_DIR} --use-compress-prog=pbzip2 -cpf ${BACKUP_WORKING_DIR}/tmp_elastic/${PLF_NAME}-es-${SCRIPT_DATE}.tar.bz2 elasticsearch  
pushd ${BACKUP_WORKING_DIR}/tmp_elastic > /dev/null 2>&1
popd > /dev/null 2>&1
echo "[INFO] Done"