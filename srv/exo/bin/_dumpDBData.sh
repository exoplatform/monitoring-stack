#!/bin/bash -eu

# #############################################################################
# Initialize
# #############################################################################
SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env settings
source ${SCRIPT_DIR}/setenv.sh
# Load common functions
source ${SCRIPT_DIR}/_functions.sh

BACKUP_DATE=${1:-$(date "+%Y-%m-%d-%H%M%S")}
SNAPSHOT_LV=$(basename ${DB_LV}-snapshot)

function remove_snapshot() {
  sudo /sbin/lvremove -f --noudevsync ${DB_LV}-snapshot 2>&1
}
echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] Data Server: Check if a previous ${DB_LV}-snapshot  exists"
echo "[INFO] ======================================="

set +e
sudo /sbin/lvdisplay "${DB_LV}-snapshot"
RET=$?
set -e

if [ $RET == 0 ]; then
  echo "[INFO] A previous snapshot was found, trying to remove it"

  echo "[INFO] Checking if the partition is mounted"
  mount_count=$(sudo /sbin/dmsetup info -c -o open --noheadings ${DB_LV}-snapshot)
  if [ $mount_count -gt 0 ]; then
    echo "[INFO] The snapshot partition is mounted, trying to unmount"
    sudo /bin/umount ${SNAPSHOT_DB_BACKUP_DIR}
  else
    echo "[INFO] The snapshot partition is no mounted"
  fi

  echo "[INFO] Removing the snapshot"
  remove_snapshot
fi
set +e
echo "[INFO] ======================================="
echo "[INFO] = Creating a snapshot of ${DB_LV} on ${SNAPSHOT_LV}"
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"
sudo /sbin/lvcreate -s -L ${LVM_SNAPSHOT_SIZE}G -n ${SNAPSHOT_LV} ${DB_LV} 2>&1
RET=$?
set -e
if [ "$RET" -ne "0" ]; then
  echo "[ERROR] ======================================="
  echo "[ERROR] = Snapshot of ${DB_LV} volume failed. See logs for more informations"
  echo "[INFO]  = Starting DB and eXo Services"
  ${SSH_COMMAND} ${SCRIPT_DIR}/_startElasticsearch.sh
  ${SSH_COMMAND} ${SCRIPT_DIR}/_startMongo.sh
  ${SSH_COMMAND} ${SCRIPT_DIR}/_startDatabase.sh
  ${SSH_COMMAND} ${SCRIPT_DIR}/_starteXo.sh
  echo "[ERROR] = Backup stopped due to previous errors"
  exit 1
fi
echo "[INFO] Done"
