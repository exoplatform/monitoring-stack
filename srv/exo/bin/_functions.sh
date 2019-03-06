#!/bin/bash -eu

#Activate aliases usage in scripts
shopt -s expand_aliases

# Various command aliases
alias display_time='/usr/bin/time -f "[INFO] Return code : %x\n[INFO] Time report (sec) : \t%e real,\t%U user,\t%S system"'
alias display_date='/bin/date +"%Y-%m-%d %H:%M:%S"'

# $1 : Startup time
# $2 : End time
delay() {
  if [ $# -lt 2 ]; then
    echo ""
    echo "[ERROR] No enough parameters for function delay !"
    exit 1;
  fi
  local _start=$1
  local _end=$2
  echo "$(( (_end - _start)/3600 )) hour(s) $(( ((_end - _start) % 3600) / 60 )) minute(s) $(( (_end - _start) % 60 )) second(s)"  
}

# $1 : Message
# $2 : Startup time
# $3 : End time
display_delay() {
  if [ $# -lt 3 ]; then
    echo ""
    echo "[ERROR] No enough parameters for function display_delay !"
    exit 1;
  fi
  echo "[INFO] $1: $(delay $2 $3) ."  
}
