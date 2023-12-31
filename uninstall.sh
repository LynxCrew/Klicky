#!/bin/bash

CONFIG_PATH="${HOME}/printer_data/config"
REPO_PATH="${HOME}/klicky"
OVERRIDES=("HOMING" "Z_TILT_ADJUST" "PROBE" "PROBE_ACCURACY" "PROBE_CALIBRATE" "BED_MESH_CALIBRATE" "QUAD_GANTRY_LEVEL")
VARIABLES=("park" "homing" "probe" "klicky" "bed_mesh")
green=$(echo -en "\e[92m")
red=$(echo -en "\e[91m")
cyan=$(echo -en "\e[96m")
white=$(echo -en "\e[39m")

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

function uninstall_macros {
    local yn
    while true; do
        read -p "${cyan}Do you really want to uninstall Klicky? (Y/n):${white} " yn
        case "${yn}" in
          Y|y|Yes|yes)
            if [ -d "${CONFIG_PATH}/Klicky" ]; then
                chmod -R 777 "${CONFIG_PATH}/Klicky"
                rm -R "${CONFIG_PATH}/Klicky"
                echo "${green}Klicky config folder removed"
            else
                echo "${red}Klicky config folder not found!"
            fi

            for OVERRIDE in ${OVERRIDES[@]}; do
                if [ -f "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg" ]; then
                    chmod -R 777 "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg"
                    rm -R "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg"
                    echo "${green}${OVERRIDE} override removed"
                else
                    echo "${red}override_${OVERRIDE}.cfg not found!"
                fi
            done

            if [ -d "${REPO_PATH}" ]; then
                chmod -R 777 "${REPO_PATH}"
                rm -R "${REPO_PATH}"
                echo "${green}Klicky folder removed"
            else
                echo "${red}Klicky folder not found!"
            fi
            break;;
          N|n|No|no|"")
            exit 0;;
          *)
            echo "${red}Invalid Input!";;
        esac
    done
}

function uninstall_variables {
    local yn
    while true; do
        read -p "${cyan}Do you also want to uninstall your configuration? (Y/n):${white} " yn
        case "${yn}" in
          Y|y|Yes|yes)
            for VARIABLE in ${VARIABLES[@]}; do
                if [ -f "${CONFIG_PATH}/Variables/${VARIABLE}_variables.cfg" ]; then
                    chmod -R 777 "${CONFIG_PATH}/Variables/${VARIABLE}_variables.cfg"
                    rm -R "${CONFIG_PATH}/Variables/${VARIABLE}_variables.cfg"
                    echo "${green}${VARIABLE} configuration removed"
                else
                    echo "${red}${VARIABLES}_variables.cfg does not exist!"
                fi
            done
            break;;
          N|n|No|no|"")
            exit 0;;
          *)
            echo "${red}Invalid Input!";;
        esac
    done
}

preflight_checks
uninstall_macros
uninstall_variables
