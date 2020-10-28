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

# Directories
PLF_SRV_DIR=/srv/exo
PLF_LOG_DIR=/srv/exo/current/logs
PLF_NAME=exo
EXO_PLF_SERVER=localhost
EXO_ES_SERVER=localhost
EXO_DB_SERVER=localhost
EXO_MONGO_SERVER=localhost
EXO_USER=exo
BACKUP_DIR=/var/backups/exo
BACKUP_WORKING_DIR=/var/backups/tmp
#Database Backup
EXO_DATABASE=exo
# The directory where the eXo "data" directory is present
EXO_DATA_DIR=/srv/data/exo
#Mongo Backup
CHAT_DATABASE=chat
#Elastic Backup
ELASTICSEARCH_DATA_DIR=/srv/data/elasticsearch
# Retrieve the backup on the server launching the restore
REMOTE_BACKUP=false
# Backup the current data before restoring
BACKUP_ON_RESTORE=true
# Number of backups to keep
BACKUP_RETENTION=7

## Server Warmup 
# This configuration allow to perform
# several requests on the server to initiate
# the js compilation and initial cache loading
WARMUP_ACTIVATED=false
WARMUP_URL=http://localhost:8080
WARMUP_USER=root
WARMUP_PASSWORD=gtn
