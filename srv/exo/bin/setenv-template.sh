#!/bin/sh -ue
#
# Copyright (C) 2003-2013 eXo Platform SAS.
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 3 of
# the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this software; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA, or see the FSF site: http://www.fsf.org.
#

# used folder for backup scripts
SCRIPT_DIR=/srv/exo/bin
# Logical Volume associated to /srv mounted partition 
EXO_LV=
DB_LV=
#LVM SNAPSHOT SIZE on GB
LVM_SNAPSHOT_SIZE=80
#Used Folders
#exo server parent Dir
PLF_SRV_DIR=/srv/exo
#exo server logs dir
PLF_LOG_DIR=/srv/exo/current/logs
#exo and DB data dirs
EXO_DATA_DIR=/srv
#SNAPSHOT Backup dir to mount lvm snapshot
SNAPSHOT_BACKUP_DIR=/var/backups/exo
SNAPSHOT_DB_BACKUP_DIR=/var/backups/exo
#Target folder for backuped data 
EXO_BCK_DIR=/mnt/nfs/backup/exo
#Temp folder used during restore data
EXO_BCK_TEMP_DIR=/var/backups/tmp_exo
# When True, data are backuped before restore
BACKUP_ON_RESTORE=true
#eXo Host
EXO_PLF_SERVER=localhost
# DB Host
EXO_DB_SERVER=localhost
# Name Used for the plaform's service
PLF_NAME=exo
# User used for backup
EXO_USER=exo
# Retentions backup on days
BACKUP_RETENTION=7

