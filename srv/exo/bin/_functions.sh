#!/bin/bash -eu

#Activate aliases usage in scripts
shopt -s expand_aliases

# Various command aliases
alias display_time='/usr/bin/time -f "[INFO] Return code : %x\n[INFO] Time report (sec) : \t%e real,\t%U user,\t%S system"'
alias display_date='/bin/date +"%Y-%m-%d %H:%M:%S"'
