#!/usr/bin/env bash
# Launch from the eXo Home

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/exo

echo "Checking current directory..."
if [ ! -e "addon" ]; then
  echo "This script must be launched in the eXo directory."
  exit 1
fi

mkdir -p ${OUTPUT_DIR}

pwd > ${OUTPUT_DIR}/0_INSTALL_DIR.txt

echo "Checking java version..."
which java > ${OUTPUT_DIR}/java_version.txt
$(which java) -version >> ${OUTPUT_DIR}/java_version.txt

echo "Checking eXo content..."
ls -al > ${OUTPUT_DIR}/root_directory.txt
ls -al lib > ${OUTPUT_DIR}/lib_directory.txt
ls -al webapps > ${OUTPUT_DIR}/webapps_directory.txt

echo "Listing installed addons..."
./addon list --installed > ${OUTPUT_DIR}/addons.lst

if [ -e "bin/setenv-customize.sh" ]; then
  source bin/setenv-customize.sh
fi

echo "Checking gatein directory..."
${SUDO} ls -al gatein > ${OUTPUT_DIR}/data.txt

DATA_DIR=gatein/data
if [ -n "${EXO_DATA_DIR}" ]; then
  echo "EXO_DATA_DIR defined, using it"
  DATA_DIR=${EXO_DATA_DIR}
  echo "Data directory : ${DATA_DIR}" >> ${OUTPUT_DIR}/data.txt
else 
  if readlink ${DATA_DIR} ; then
    DATA_DIR=$(readlink -f ${DATA_DIR})
  fi
  echo -n  "Data directory : ${DATA_DIR}" >> ${OUTPUT_DIR}/data.txt
fi

${SUDO} ls -al ${DATA_DIR} >> ${OUTPUT_DIR}/data.txt

echo "Checking gatein directory sizes..."
echo > ${OUTPUT_DIR}/data_sizes.txt
${SUDO} ls gatein/data | xargs -n1 -i{} sudo du -sh gatein/data/{} >> ${OUTPUT_DIR}/data_sizes.txt
echo >> ${OUTPUT_DIR}/data_sizes.txt
${SUDO} ls gatein/data/jcr | xargs -n1 -i{} sudo du -sh gatein/data/jcr/{} >> ${OUTPUT_DIR}/data_sizes.txt
echo >> ${OUTPUT_DIR}/data_sizes.txt
${SUDO} ls gatein/data/jcr/index | xargs -n1 -i{} sudo du -sh gatein/data/jcr/index/{} >> ${OUTPUT_DIR}/data_sizes.txt
echo >> ${OUTPUT_DIR}/data_sizes.txt

echo "Getting server.xml..."
# TODO obfuscation
${SUDO} cp conf/server.xml ${OUTPUT_DIR}/server.xml

echo "Getting setenv-customize.sh..."
if [ -e bin/setenv-customize.sh ]; then
    cat bin/setenv-customize.sh | grep -v -e "^#" -e '^[\t\s]*$' > ${OUTPUT_DIR}/setenv-customize.sh
else
    touch ${OUTPUT_DIR}/setenv-customize.sh.absent
fi

echo "Getting exo.properties..."
cat gatein/conf/exo.properties | grep -v -e "^#" -e '^[\t\s]*$' | sort > ${OUTPUT_DIR}/exo.properties

echo "Getting log statistics..."
echo "   INFO"
echo -n "INFO : " > ${OUTPUT_DIR}/logs_categories.txt
${SUDO} cat logs/platform.log | grep -c INFO >> ${OUTPUT_DIR}/logs_categories.txt
echo "   WARN"
echo -n "WARN : " >> ${OUTPUT_DIR}/logs_categories.txt
${SUDO} cat logs/platform.log | grep -c WARN >> ${OUTPUT_DIR}/logs_categories.txt
echo "   ERROR"
echo -n "ERROR : " >> ${OUTPUT_DIR}/logs_categories.txt
${SUDO} cat logs/platform.log | grep -c ERROR >> ${OUTPUT_DIR}/logs_categories.txt

echo "Checking todays connections..."
${SUDO} cat logs/platform.log | grep -c logged > ${OUTPUT_DIR}/today_connections.txt

echo "Getting full log files..." 
echo "  platform.log"
${SUDO} cat logs/platform.log > ${OUTPUT_DIR}/platform.log
echo "  catalina.out"
${SUDO} cat logs/catalina.out > ${OUTPUT_DIR}/catalina.out
echo "Compressing log files"
gzip -9 ${OUTPUT_DIR}/platform.log ${OUTPUT_DIR}/catalina.out

# TODO jstat pendant 30s
echo "Generating memory profile..."
if ! command -v jstat; then
  echo "jstat command not found in path"
  echo "" > ${OUTPUT_DIR}/jstat.notfound
else
    jstat -gc $(jps | grep Bootstrap | cut -f1 -d" ") 2000 30 | tee ${OUTPUT_DIR}/gc_stats.txt
fi

# Chat
${SUDO} cat gatein/conf/chat.properties | grep -v -e "^#" -e '^[\t\s]*$' > ${OUTPUT_DIR}/chat.properties

echo ""
echo "eXo audit done."
echo "Result are stored on ${OUTPUT_DIR} directory"
