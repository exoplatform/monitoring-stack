#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/mongo

function usage() {
    echo "$0 [-a] [-h] [-u <username>"
    echo "-a            : activate mongo authentication"
    echo "-i <ip>       : ip to connect to default: localhost"
    echo "-u <username> : use this username to connect to mongo"
    echo "-h            : display this help"
}

AUTH=false
USER=""
AUTH_STRING=""
IP=""

while getopts "hai:u:" opt; do
  case $opt in 
    h)
      usage
      exit 1
      ;;
    a)
      echo "Activating authentication"
      AUTH=true
      ;;
    i)
      IP=${OPTARG}
      echo "Connect to $IP"
      ;;
    u)
      echo "Activating authentication"
      AUTH=true

      USER=${OPTARG}
      echo "Using ${USER} to connect to mongo"
      ;;
    esac
done

if $AUTH; then
  if [[ -z "$USER" ]]; then
    read -p "Mongo user : " USER
  fi
  read -s -p "$USER password :" PASS
  AUTH_STRING="-u $USER -p $PASS "
fi

MONGO_CMD="mongo $AUTH_STRING"

if [[ -n "$IP" ]]; then
  MONGO_CMD="$MONGO_CMD $IP/chat"
fi

mkdir -p ${OUTPUT_DIR}

echo "Checking main configuration file..."
cat /etc/mongod.conf > ${OUTPUT_DIR}/mongod.conf

echo "Checking runtime configuration..."
echo "db._adminCommand( {getCmdLineOpts: 1})" | $MONGO_CMD > ${OUTPUT_DIR}/runtime-configuration.json

echo "Checking version..."
echo "" | mongo > ${OUTPUT_DIR}/version.lst

echo "Checking parameters..."
echo "db._adminCommand({getParameter:"*"})" | $MONGO_CMD > ${OUTPUT_DIR}/parameters.lst

echo "Checking databases..."
echo "show dbs" | $MONGO_CMD > ${OUTPUT_DIR}/databases.lst

echo "Checking collections..."
# TODO automatically detect the chat database's name
echo "show collections" | $MONGO_CMD chat > ${OUTPUT_DIR}/collections.lst

# TODO Retrieve data dir and check size

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
