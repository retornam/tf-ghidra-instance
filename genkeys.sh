#!/usr/bin/env bash

set -euo pipefail 

PREFIX="${1:-ghidraserver}"
REALPATH=$(realpath "$0")
DIRECTORY=$(dirname "$REALPATH")
STATEFILE="${DIRECTORY}/terraform.tfstate"
KEYSDIR="${DIRECTORY}/keys"
PRIVPEM="${KEYSDIR}/${PREFIX}.pem"
PUBKEY="${KEYSDIR}/${PREFIX}.pub"
INSTANCE_IP="${KEYSDIR}/instanceip"

if [[ -f ${STATEFILE} ]]; then
	if [[ ! -f ${PRIVPEM} ]]; then
		terraform output -raw private_key_pem >  "${PRIVPEM}"
		chmod 600 "${PRIVPEM}"
		terraform output -raw public_key_openssh > "${PUBKEY}"
        terraform output instance_ip | awk '{ gsub(/"/,"")  } $1' > "${INSTANCE_IP}" 
	else
		printf "Keys exist \n"
		printf "Exiting..... \n"
	fi
fi
