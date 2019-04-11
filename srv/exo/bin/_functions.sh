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

# $1 : Action
# $2 : Service 
systemd_action(){
  if [ $# -lt 2 ]; then
    echo ""
    echo "[ERROR] No enough parameters for function systemd_action !"
    exit 1;
  fi
  case $1 in
	start)
		sudo systemctl start $2
    if $(sudo systemctl -q is-active $2); then
      echo "[INFO] Service $2 started successfuly"
    else 
      echo "[ERROR] Service $2 failed to start"
      exit 1;
    fi
		;;
	stop)
    echo "[INFO] Stop $2 service"
		sudo systemctl stop $2		
		;;
  status)  
    sudo systemctl status $2
    break
    ;;
	*)
		 echo "[ERROR] No systemd action defined !"
    exit 1;
		;;
  esac
 
}
