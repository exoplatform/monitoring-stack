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
echo "[INFO] Mounting snapshot on ${SNAPSHOT_DB_BACKUP_DIR}"
echo "[INFO] ======================================="

sudo /bin/mount ${DB_LV}-snapshot ${SNAPSHOT_DB_BACKUP_DIR}
if [ $? -ne 0 ]; then
  echo "[ERROR] Error mounting snapshot ${DB_LV}-snapshot in ${SNAPSHOT_DB_BACKUP_DIR} dir"
  echo "[ERROR] ${LOG_FILE} for more informations"
  exit 1
fi
echo "Done"

#transfer backuped data to nfs
TARGET="${EXO_BCK_DIR}/srv-data-${BACKUP_DATE}.tar.bz2"
echo "[INFO] ======================================="
echo "[INFO] = Compressing /srv files from ${SNAPSHOT_DB_BACKUP_DIR} into ${TARGET} ..."
echo "[INFO] ======================================="

time sudo /bin/tar --directory ${SNAPSHOT_DB_BACKUP_DIR} --use-compress-prog=pbzip2 -cpf ${TARGET} data
if [ $? -ne 0 ]; then
  echo "[ERROR] Error adding backup to ${SNAPSHOT_DB_BACKUP_DIR} dir"
  echo "[ERROR] See ${LOG_FILE} for more informations"
  exit 1
fi
echo "[INFO] Done"

# Release snapshot
echo "[INFO] ======================================="
echo "[INFO] unmounting snapshot ${SNAPSHOT_DB_BACKUP_DIR}"
echo "[INFO] ======================================="

sudo /bin/umount ${SNAPSHOT_DB_BACKUP_DIR}

echo "[INFO] Waiting to the umount to be effective"
retry=0
mount_count=1

while [ ${mount_count} -gt 0 -a ${retry} -lt 10 ]
do
  sleep 1
  mount_count=$(sudo /sbin/dmsetup info -c -o open --noheadings ${DB_LV}-snapshot)
  echo "[INFO] Mount count ${mount_count}"
  retry=$(( $retry + 1 ))
done

if [ $retry -ge 10 ]; then
  echo "[ERROR] Max umount retry reached ($retry/10). Please check the server status"
  exit 1
fi

echo "[INFO] Done"

echo "[INFO] ======================================="  
echo "[INFO] = Deleting snapshot ${DB_LV}-snapshot"
echo "[INFO] ======================================="
remove_snapshot

echo "[INFO] Done"