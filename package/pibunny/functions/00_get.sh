#!/usr/bin/env bash

function GET() {
	echo ${FUNCNAME[0]} $@
	local LEASEFILE="/var/dhcpd.leases"

	case ${1} in
	"TARGET_IP")
		export TARGET_IP=$(cat ${LEASEFILE} | grep ^lease | awk '{ print $2 }' | sort | uniq)
		return
		;;
	"TARGET_HOSTNAME")
		export TARGET_HOSTNAME=$(cat ${LEASEFILE} | grep hostname | awk '{print $2 }' |
			sort | uniq | tail -n1 | sed "s/^[ \t]*//" | sed 's/\"//g' | sed 's/;//')
		return
		;;
	"HOST_IP")
		export HOST_IP="172.16.64.1"
		return
		;;
	"SWITCH_POSITION")
		export SWITCH_POSITION=$(cat /tmp/switchpos)
		return
		;;
	"TARGET_OS")
		TARGET_IP=$(cat ${LEASEFILE} | grep ^lease | awk '{ print $2 }' | sort | uniq)
		ScanForOS=$(nmap -Pn -O ${TARGET_IP} -p1 -v2)
		[[ $ScanForOS == *"Too many fingerprints"* ]] && ScanForOS=$(nmap -Pn -O ${TARGET_IP} --osscan-guess -v2)
		[[ "${ScanForOS,,}" == *"windows"* ]] && export TARGET_OS='WINDOWS'
		[[ "${ScanForOS,,}" == *"apple"* ]] && export TARGET_OS='MACOS'
		[[ "${ScanForOS,,}" == *"linux"* ]] && export TARGET_OS='LINUX'
		export TARGET_OS='UNKNOWN'
		return
		;;
	esac
}

export -f GET
