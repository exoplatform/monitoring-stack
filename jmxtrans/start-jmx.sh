#!/usr/sbin/env bash

JMXTRANX_VERSION=270
JMXTRANS_BASE_URL=http://central.maven.org/maven2/org/jmxtrans/jmxtrans/${JMXTRANS_VERSION}/jmxtrans-${VERSION}
#http://central.maven.org/maven2/org/jmxtrans/jmxtrans/270/jmxtrans-270.rpm
#http://central.maven.org/maven2/org/jmxtrans/jmxtrans/270/jmxtrans-270.deb


check_wget_installation() {
    type -p wget
    if [ $? -ne 0 ]; then
      echo "ERROR wget command not found. please install it and retry"
      exit 1
    fi
}

JMX_HOME=/opt/jmxtrans

# TODO WIP compute download url and install command based on linux distribution
# TODO long term support windows

# TODO WIP check where jmxtrans binary is after install instead of wrong home
if [ ! -d ${JMX_HOME} ]; then
    check_wget_installation
    wget ${JMX_TRANS_URL}
    if [ $? -ne 0 ]; then
      echo "Unable to download the jmxtrans binary at ${JMX_TRANS_URL}"
      echo "Please try to download it and install it manuallu with :"
      echo "wget ${JMXTRANS_URL}"
      echo "${INSTALL_CMD}"
fi

