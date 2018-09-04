#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/database

mkdir -p ${OUTPUT_DIR}

echo "Checking main configuration file..."
cat /etc/postgresql/*/main/postgresql.conf > ${OUTPUT_DIR}/postgresql.conf
cat /etc/postgresql/*/main/postgresql.conf | sed 's/#.*//g' | tr -d '[:blank:]' | grep -v -e '^[\t\s]*$' > ${OUTPUT_DIR}/postgresql-lite.conf

source ${OUTPUT_DIR}/postgresql-lite.conf

# TODO Ask for for the database user and database

echo "Checking configuration..."
echo "show all" | psql -U exo -W exo > ${OUTPUT_DIR}/variables.lst

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
popd || exit
