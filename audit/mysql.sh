#!/usr/bin/env bash

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=.
source ${SCRIPT_DIR}/_functions.sh

OUTPUT_DIR=${AUDIT_OUTPUT_BASE}/database

mkdir -p ${OUTPUT_DIR}

function usage() {
    echo "$0 [-a] [-h] [-u <username>"
    echo "-a            : activate authentication"
    echo "-i <ip>       : ip to connect to default: localhost"
    echo "-u <username> : use this username to connect to"
    echo "-h            : display this help"
}

AUTH=false
USER=""
AUTH_STRING=""
IP=""

while getopts "hai:u:" opt; do
  case $opt in 
    h)
      usage
      exit 1
      ;;
    a)
      echo "Activating authentication"
      AUTH=true
      ;;
    i)
      IP=${OPTARG}
      echo "Connect to $IP"
      ;;
    u)
      echo "Activating authentication"
      AUTH=true
      
      USER=${OPTARG}
      echo "Using ${USER} user"
      ;;
    esac
done

if $AUTH; then
  if [[ -z "$USER" ]]; then
    read -p "User : " USER
  fi
  read -s -p "$USER password :" PASS
  AUTH_STRING="-u $USER -p$PASS "
fi

MYSQL_CMD="mysql $AUTH_STRING"

if [[ -n "$IP" ]]; then
  MYSQL_CMD="$MYSQL_CMD -h $IP"
fi

echo "Getting main configuration file..."
cat /etc/my.cnf > ${OUTPUT_DIR}/my.cnf
cp -r /etc/my.cnf.d ${OUTPUT_DIR}

DATA_DIR=$(grep datadir /etc/my.cnf | awk -F '=' '{print $2}')

echo "Getting size of data dir ${DATA_DIR}..."
${SUDO} du -sch $DATA_DIR/* > ${OUTPUT_DIR}/size.txt

echo "Getting engine status..."
${MYSQL_CMD} -e "show engine innodb status"  > ${OUTPUT_DIR}/innodb_status.txt

echo "Getting version..."
${MYSQL_CMD} -e "select version();" > ${OUTPUT_DIR}/version.txt

echo "Getting variables..."
${MYSQL_CMD} -e "show variables;" > ${OUTPUT_DIR}/variables.txt

echo "Getting status..."
${MYSQL_CMD} -e "show status;" > ${OUTPUT_DIR}/status.txt

echo "Getting logs..."
for f in $(ls /var/log/mysql*); do
  echo "  $f"
  d="$OUTPUT_DIR/$(basename $f)"
  echo "    copying..."
  ${SUDO} cat $f > $d
  echo "    compressing..."
  gzip -9 $d
done

echo "Trying to execute mysqltuner..."
if [[ ! -e "${SCRIPT_DIR}/mysqltuner.pl" ]]; then
  echo "  mysqltuner.pl not found, trying to download it..."
  if ! curl -f https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl > ${SCRIPT_DIR}/mysqltuner.pl; then
    echo "  Unable to download the file"
    MYSQL_TUNER=false
  else
    MYSQL_TUNER=true
  fi
else
  MYSQL_TUNER=true
fi

if [[ $MYSQL_TUNER == true ]]; then
  chmod u+x mysqltuner.pl
  MT_AUTH=""
  if $AUTH; then
    MT_AUTH="--user $USER --pass $PASS"
  fi
  ${SCRIPT_DIR}/mysqltuner.pl $MT_AUTH --outputfile ${OUTPUT_DIR}/mysqltuner.txt --reportfile ${OUTPUT_DIR}/mysqltuner_report.txt
else
  echo "mysqltuner executable not present"
fi  

echo ""
echo "Result are stored on ${OUTPUT_DIR}"
