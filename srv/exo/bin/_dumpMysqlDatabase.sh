#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################                                              
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# Load env settings
source ${SCRIPT_DIR}/_setenv-template.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

DUMP_OPTIONS="--single-transaction"

# Initialize working directory
rm -rf ${DB_DUMP_WORKING_DIR}/*
pushd ${DB_DUMP_WORKING_DIR} > /dev/null 2>&1

echo "[INFO] ======================================="
echo "[INFO] = Dumping database ${PLF_DATABASE_NAME} into ${DB_DUMP_WORKING_DIR} ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

display_time sudo mysqldump ${DUMP_OPTIONS} ${PLF_DATABASE_NAME} > ${DB_DUMP_WORKING_DIR}/${PLF_DATABASE_NAME}-dumpDataBase.sql

echo "[INFO] $(display_date)"
echo "[INFO] Done

popd > /dev/null 2>&1
