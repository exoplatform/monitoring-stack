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
SNAPSHOT_LV=$(basename ${EXO_LV}-snapshot)

function remove_snapshot() {
  sudo /sbin/lvremove -f --noudevsync ${EXO_LV}-snapshot 2>&1
}
echo "[INFO] $(display_date)"
echo "[INFO] ======================================="
echo "[INFO] EXO Server Check if a previous ${EXO_LV}-snapshot  exists"
echo "[INFO] ======================================="

set +e
sudo /sbin/lvdisplay "${EXO_LV}-snapshot"
RET=$?
set -e

if [ $RET == 0 ]; then
  echo "[INFO] A previous snapshot was found, trying to remove it"

  echo "[INFO] Checking if the partition is mounted"
  mount_count=$(sudo /sbin/dmsetup info -c -o open --noheadings ${EXO_LV}-snapshot)
  if [ $mount_count -gt 0 ]; then
    echo "[INFO] The snapshot partition is mounted, trying to unmount"
    sudo /bin/umount ${SNAPSHOT_BACKUP_DIR}
  else
    echo "[INFO] The snapshot partition is no mounted"
  fi

  echo "[INFO] Removing the snapshot"
  remove_snapshot
fi
set +e
echo "[INFO] ======================================="
echo "[INFO] = Creating a snapshot of ${EXO_LV} on ${SNAPSHOT_LV}"
echo "[INFO] ======================================="
echo "[INFO] $(display_date)"
sudo /sbin/lvcreate -s -L ${LVM_SNAPSHOT_SIZE}G -n ${SNAPSHOT_LV} ${EXO_LV} 2>&1
RET=$?
set -e
if [ "$RET" -ne "0" ]; then
  echo "[ERROR] ======================================="
  echo "[ERROR] = Snapshot of ${EXO_LV} volume failed. See logs for more informations"
  echo "[INFO]  = Starting eXo Service"
  ${SSH_COMMAND} ${SCRIPT_DIR}/_starteXo.sh
  echo "[ERROR] = Backup stopped due to previous errors"
  exit 1
fi
echo "[INFO] Done"
