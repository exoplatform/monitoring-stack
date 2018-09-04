#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/elasticsearch

mkdir -p ${OUTPUT_DIR}

ES_URL="http://localhost:9200"

echo "Checking main version..."
curl -v -s ${ES_URL} > ${OUTPUT_DIR}/home.json  2> ${OUTPUT_DIR}/home.log

echo "Checking _cat endoints..."
mkdir -p ${OUTPUT_DIR}/cat
for uri in $(curl -s ${ES_URL}/_cat | grep -v -e "^=" -e "{"); do
  filename=$(echo ${uri} | sed 's|/_cat/||g')
  echo "  ${filename}"
  curl -v -s "${ES_URL}${uri}?v" > ${OUTPUT_DIR}/cat/${filename}.txt 2>${OUTPUT_DIR}/cat/${filename}.log
done

echo "Checking cluster health..."
curl -s -v "http://localhost:9200/_cluster/health?pretty" > ${OUTPUT_DIR}/cluster-health.json  2> ${OUTPUT_DIR}/cluster-health.log

echo "Checking cluster state..."
curl -s -v "http://localhost:9200/_cluster/state?pretty" > ${OUTPUT_DIR}/cluster-state.json  2> ${OUTPUT_DIR}/cluster-state.log

echo "Checking cluster stats..."
curl -s -v "http://localhost:9200/_cluster/stats?pretty&human" > ${OUTPUT_DIR}/cluster-stats.json  2> ${OUTPUT_DIR}/cluster-stats.log

echo "Checking nodes configuration..."
curl -s -v "http://localhost:9200/_nodes?pretty" > ${OUTPUT_DIR}/nodes.json  2> ${OUTPUT_DIR}/nodes.log

echo "Checking nodes health..."
curl -s -v "http://localhost:9200/_nodes/health?pretty"  > ${OUTPUT_DIR}/nodes-health.json  2> ${OUTPUT_DIR}/nodes-health.log

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
