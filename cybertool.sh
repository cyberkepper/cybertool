#!/bin/bash

# Author: Alex Grande @Cybermatica
# Date: Mayo 2021

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

# Salida al cortar la ejecucion del programa
function ctrl_c(){
	echo -e "\n${redColour}[!] Saliendo...\n${endColour}"
	tput cnorm; exit 0
}

# Menu de acciones
function scanPhase(){
	echo -e "\n${redColour}[!] FASE DE RENOCIMIENTO ${endColour}"
	echo -e "\n\t${grayColour}[-a]${endColour}${yellowColour} Escaneo normal de puertos: ej: ./cybertool.sh -a 10.10.10.10 ${endColour}"
	echo -e "\n\t${grayColour}[-b]${endColour}${yellowColour} Escaneo rapido de puertos: ej: ./cybertool.sh -b 10.10.10.10 ${endColour}"
	exit 0
}

function viewScanInfo(){
	echo -e "\n\t${grayColour}[i] Host remoto: ${yellowColour}$targetIp${endColour}"
	echo -e "\n\t${grayColour}[i] Puertos abiertos: ${yellowColour}$ports${endColour}"
}

function readPorts() {
	ports="$(cat allPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	rm allPorts
}

function basicPortScanner(){
	echo -e "\n\t${grayColour}[*]${yellowColour} Modo escaneo de puertos normal${endColour}"
	nmap -p- --open -T5 -v -n $targetIp -oG allPorts
	readPorts
	viewScanInfo
}

function quickPortScanner(){
	echo -e "\n\t${grayColour}[*]${yellowColour} Modo escaneo de puertos rapido${endColour}"
	nmap -p- -sS -min-rate 5000 --open -n -Pn -vvv $targetIp -oG allPorts
	readPorts
	viewScanInfo
}

function dirEnum() {
	gobuster dir -u $targetIp -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 20
}

declare -i parameter_counter=0; while getopts "a:b:h:" arg; do
	case $arg in
		a) targetIp=$OPTARG; basicPortScanner; let parameter_counter+=1 ;;
		b) targetIp=$OPTARG; quickPortScanner; let parameter_counter+=1 ;;
		h) scanPhase ;;
	esac
done
