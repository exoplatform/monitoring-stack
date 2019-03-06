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
EXO_PLF_SERVER=${PLF_SERVER}
EXO_ES_SERVER=${ES_SERVER}
EXO_DB_SERVER=${DB_SERVER}
EXO_MONGO_SERVER=${MONGO_SERVER}
EXO_USER=exo
#Database Backup
DB_DUMP_WORKING_DIR=/srv/backup
PLF_DATABASE_NAME=exo
