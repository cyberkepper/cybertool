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
	echo -e "\n${redColour}[!] Menu principal\n${endColour}"
	menu
}
# Menu principal
function menu(){
	tput civis;
	echo -e "\n${redColour}[!] Menu principal${endColour}"
    echo -e "\n${yellowColour}[!]${grayColour} Seleccione una opcion: ${endColour}"

    #  Seleccion de fases
    echo -e "\n\t${yellowColour}[!]${grayColour} [1] RECONOCIMIENTO ${endColour}"
    echo -e "\n\t${yellowColour}[!]${grayColour} [2] ENUMERACION WEB ${endColour}"
    echo -e "\n\t${yellowColour}[!]${grayColour} [3] VER IP Y PUERTOS ABIERTOS ${endColour}"
	echo -e "\n\t${yellowColour}[!]${grayColour} [4] INFORMACION DE SERVICIOS ${endColour}"
	echo -e "\n\t${yellowColour}[!]${grayColour} [exit] SALIR${endColour}"
    read action
	if [ $action == "1" ]; then
    	recTools
    elif [ $action == "2" ]; then
    	enumTools
    elif [ $action == "3" ]; then
    	viewInfo
    elif [ $action == "4" ]; then
    	readServices
	elif [ $action == "exit" ]; then
		exitProgram
    else
      	menu
    fi
}

function exitProgram(){
	echo -e "\n${redColour}[!] Saliendo...\n${endColour}"
	rm targeted allPorts
	tput cnorm; exit 0
}

# Mennu de la fase de reconocimiento
function recTools(){
	clear
	echo -e "\n\t${redColour}[!] FASE DE RECONOCIMIENTO ${endColour}"

	if [ ! $targetIp ]; then
        echo -e "\n\t${redColour}[!] Necesitas introducir la ip del host remoto: ej: 10.10.10.10 ${endColour}" &&
        read targetIp
    fi

	echo -e "\n\t${grayColour}[!]${endColour}${yellowColour} [1] Escaneo normal de puertos${endColour}"
	echo -e "\n\t${grayColour}[!]${endColour}${yellowColour} [2] Escaneo rapido de puertos${endColour}"
	echo -e "\n\t${grayColour}[!]${endColour}${yellowColour} [3] Escaneo de servicios${endColour}"
	read scanType
	if [ $scanType == "1" ]; then
		normalPortScanner
	elif [ $scanType == "2" ]; then
		fastPortScanner
	elif [ $scanType == "3" ]; then
		serviceScanner
	else
		menu
	fi

}

# Menu de herramientas de enumeración
function enumTools(){
	clear
	echo -e "\n\t${redColour}[!] HERRAMIENTAS DE ENUMERACION WEB ${endColour}"

	if [ ! $targetIp ]; then
		echo -e "\n\t${redColour}[!] Necesitas introducir la ip del host ${endColour}"
		menu
	fi

	echo -e "\n\t${yellowColour}[!]${grayColour} Seleccione la herramienta: ${endColour}"

	# Herramientas de enumeracion web por el puerto 80 TODO: Desbloquearla por otro puerto http
	if [ "$(cat targeted | grep 80 | awk '{print $1}' | tail -n 1)" == "80/tcp" ]; then

		echo -e "\n\t${yellowColour}[!]${grayColour} [1] GoBuster${endColour}"
		echo -e "\n\t${yellowColour}[!]${grayColour} [2] ffuf${endColour}"
		read enumTool
		if [ $enumTool == "1" ]; then
			goBusterEnum
		elif [ $enumTool == "2" ]; then
			ffufEnum
		else
			menu
		fi
	fi

}

# Ver información de Ip y puertos que tiene la máquina
function viewInfo(){
	clear
	echo -e "\n${grayColour}[i] Host remoto: ${yellowColour}$targetIp${endColour}"
	echo -e "\n${grayColour}[i] Puertos abiertos: ${yellowColour}$ports${endColour}"
	menu
}

# Leer puertos escaneados
function readPorts() {
	ports="$(cat allPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
}

# Leer servicios escaneados
function readServices() {
	clear
	cat targeted
	menu
}

# Escaneo básico de puertos
function normalPortScanner(){
	clear
	echo -e "\n\t${grayColour}[*]${yellowColour} Modo escaneo de puertos normal${endColour}"
	nmap -p- --open -T5 -v -n $targetIp -oG allPorts
	readPorts
	menu
}

# Escaneo rápido de puertos
function fastPortScanner(){
	clear
	echo -e "\n\n\t${grayColour}[*]${yellowColour} Modo escaneo de puertos rapido${endColour}"
	nmap -p- -sS -min-rate 5000 --open -n -Pn -vvv $targetIp -oG allPorts
	readPorts
	menu
}

# Escaneo de servicios en los puertos escaneados
function serviceScanner() {
	clear
	echo -e "\n\n\t${grayColour}[*]${yellowColour} Escaneo de servicios por puerto${endColour}"
	nmap $targetIp -p$ports -sC -sV -oN targeted
	menu
}

# Enumeración de directorios con goBuster
function goBusterEnum() {
	clear
	echo -e "\n\t${grayColour}[*]${yellowColour} Enumeración de directorios con goBuster${endColour}"
	gobuster dir -u $targetIp -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 20
	menu
}

# Enumeracion de archivos con ffuf
function ffufEnum() {
	clear
	echo -e "\n\t${grayColour}[*]${yellowColour} Enumeracion de archivos con ffuf${endColour}"
	ffuf -u http://$targetIp/FUZZ -w /usr/share/wordlists/dirb/common.txt -c --recursion
	menu
}

menu
