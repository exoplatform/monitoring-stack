#!/usr/bin/env bash

AUDIT_OUTPUT_BASE="/tmp/exo-audit"

# Detect OS Type
if [ ! -e /etc/os-release ]; then 
  echo "Unable to detect os type via /etc/os-release file"
  exit 1
fi

source /etc/os-release

if [ -z "$ID" ]; then
  echo "ID variable not specified on the /etc/os-release file"
  exit 1
fi

OS="${ID}"
OS_TYPE="$(echo "${ID_LIKE:-$ID}" | awk '{print $1}')"   # for centos ID_LIKE = "rhel fedora)"

echo "OS detected : ${OS}"
echo "OS type : ${OS_TYPE}"

USER=$(whoami)

if [ "${USER}" != "root" ]; then
  echo "Running as ${USER}, sudo will be used when needed"
  SUDO="sudo "
fi
