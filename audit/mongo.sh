#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/mongo

mkdir -p ${OUTPUT_DIR}

echo "Checking main configuration file..."
cat /etc/mongod.conf > ${OUTPUT_DIR}/mongod.conf

echo "Checking runtime configuration..."
echo "db._adminCommand( {getCmdLineOpts: 1})" | mongo > ${OUTPUT_DIR}/runtime-configuration.json

echo "Checking version..."
echo "" | mongo > ${OUTPUT_DIR}/version.lst

echo "Checking parameters..."
echo "db._adminCommand({getParameter:"*"})" | mongo > ${OUTPUT_DIR}/parameters.lst

echo "Checking databases..."
echo "show dbs" | mongo > ${OUTPUT_DIR}/databases.lst

echo "Checking collections..."
# TODO automatically detect the chat database's name
echo "show collections" | mongo chat > ${OUTPUT_DIR}/collections.lst

# TODO Retrieve data dir and check size

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
