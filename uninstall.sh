#!/bin/bash

CONFIG_PATH="${HOME}/printer_data/config"
KLICKY_PATH="${HOME}/klicky"

set -eu
export LC_ALL=C


function preflight_checks {
    if [ "$EUID" -eq 0 ]; then
        echo "[PRE-CHECK] This script must not be run as root!"
        exit -1
    fi

    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F 'klipper.service')" ]; then
        printf "[PRE-CHECK] Klipper service found! Continuing...\n\n"
    else
        echo "[ERROR] Klipper service not found, please install Klipper first!"
        exit -1
    fi
}

funtion uninstall_macros {
    local yn
    while true; do
        read -p "${blue}Do you really want to uninstall Klicky? (Y/n):${white} " yn
        case "${yn}" in
          Y|y|Yes|yes)
            if [ -d "${CONFIG_PATH}/Klicky" ]; then
                chmod -R 777 "${CONFIG_PATH}/Klicky"
                rm -R "${CONFIG_PATH}/Klicky"
            else
                echo "${red}Klicky Config folder not found!"
                exit -1
            fi

            if [ -d "${KLICKY_PATH}" ]; then
                chmod -R 777 "${KLICKY_PATH}"
                rm -R "${KLICKY_PATH}"
            else
                echo "${red}Klicky folder not found!"
                exit -1
            fi
          N|n|No|no|"")
            exit 0
          *)
            echo "${red}Invalid Input!"
        esac
    done
}

function uninstall_variables {
    local yn
    while true; do
        read -p "${blue}Do you also want to uninstall your configuration? (Y/n):${white} " yn
        case "${yn}" in
          Y|y|Yes|yes)
            if [ -f "${CONFIG_PATH}/Variables/klicky_variables.cfg" ]; then
                chmod -R 777 "${CONFIG_PATH}/Variables/klicky_variables.cfg"
                rm -R "${CONFIG_PATH}/Variables/klicky_variables.cfg"
            else
                echo "${red}klicky_variables.cfg does not exist!"
            fi
          N|n|No|no|"")
            exit 0
          *)
            echo "${red}Invalid Input!"
        esac
    done
}

preflight_checks
uninstall_macros
uninstall_variables
