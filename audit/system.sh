#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=/tmp/exo-audit/system

mkdir -p ${OUTPUT_DIR}
pushd ${OUTPUT_DIR} || exit

date +%Y%m%d-%H%M > ${OUTPUT_DIR}/0_REPORT_DATE

echo "Generating hostname..."
hostname > hostname.txt

echo "Getting distribution details..."
cat /etc/*-release > distribution.txt
uname -a > kernel.txt

echo "Checking authorized keys..."
cat ~/.ssh/authorized_keys > ssh_accesses.txt

echo "Checking memory details "
free > memory.txt
cat /proc/swaps > swap.txt

echo "Checking network interfaces..."
ip a > network.txt
ss -l -n -t > network_open_ports.txt

echo "Checking cpus..."
cp /proc/cpuinfo cpuinfo.txt

echo "Capturing running processes..."
ps -ef > processes.txt

echo "Checking raid configuration..."
if [ -e '/proc/mdstat' ]; then
  cat /proc/mdstat > md.txt
else 
  echo "No software raids detected (no /proc/mdstat file)" > md.txt
fi

echo "Checking lvm installation..."
if [ -e "/sbin/lvdisplay" ]; then
  # TODO use sudo
  ${SUDO} pvdisplay > lvm.txt
  ${SUDO} vgdisplay >> lvm.txt
  ${SUDO} lvdisplay >> lvm.txt
else
  echo "LVM not detected"
  echo "" > lvm.notinstalled
fi

echo "Checking mount point..."
cp /etc/fstab fstab
mount > mounts.txt

echo "Checking partition spaces..."
df -h > disk_space.txt

echo "Checking kernel configuration..."
/sbin/sysctl -a > sysctl.lst

if [ -e /etc/monitrc ]; then
  tar cvjf monit.tar.gz /etc/monitrc /etc/monit.d
fi

echo "Checking backup manager usage..."
if [ -e /etc/backup-manager.conf ]; then
  echo "Backup manager detected"
  cp -v /etc/backup-manager.conf .
else
  echo "Backup manager not detected"
  echo "" > backup-manager.notused
fi

echo ""
echo "Result are stored on $(pwd)"
popd || exit
