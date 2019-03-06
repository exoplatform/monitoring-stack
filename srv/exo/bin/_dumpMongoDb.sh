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

# Initialize working directory
rm -rf ${MONGODB_DUMP_WORKING_DIR}/*
pushd ${MONGODB_DUMP_WORKING_DIR} > /dev/null 2>&1

# settings : http://docs.mongodb.org/manual/single/index.html#document-tutorial/backup-databases-with-binary-database-dumps

echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] = Dumping MongoDB ${EXO_CHAT_MONGODB_NAME} into ${MONGODB_DUMP_WORKING_DIR} ..."
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"

display_time sudo mongodump -o ${MONGODB_DUMP_WORKING_DIR} --db=${EXO_CHAT_MONGODB_NAME}

echo "[INFO] Done"
echo "[INFO] $(display_date)"

popd > /dev/null 2>&1