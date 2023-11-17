#!/bin/bash

CONFIG_PATH="${HOME}/printer_data/config"
KLICKY_PATH="${HOME}/klicky"
OVERRIDES=("HOMING" "Z_TILT_ADJUST" "PROBE" "PROBE_ACCURACY" "PROBE_CALIBRATE")
VARIABLES=("park" "homing" "probe" "klicky")

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

function check_download {
    local klickydirname klickybasename
    klickydirname="$(dirname ${KLICKY_PATH})"
    klickybasename="$(basename ${KLICKY_PATH})"

    if [ ! -d "${KLICKY_PATH}" ]; then
        echo "[DOWNLOAD] Downloading Klicky repository..."
        if git -C $klickydirname clone https://github.com/LynxCrew/Klicky.git $klickybasename; then
            chmod +x ${KLICKY_PATH}/install.sh
            chmod +x ${KLICKY_PATH}/update.sh
            chmod +x ${KLICKY_PATH}/uninstall.sh
            printf "[DOWNLOAD] Download complete!\n\n"
        else
            echo "[ERROR] Download of Klicky git repository failed!"
            exit -1
        fi
    else
        printf "[DOWNLOAD] Klicky repository already found locally. Continuing...\n\n"
    fi
}

function link_extension {
    echo "[INSTALL] Linking extension to Klipper..."
    
    if [ -d "${CONFIG_PATH}/Klicky" ]; then
        chmod -R 777 "${CONFIG_PATH}/Klicky"
        rm -R "${CONFIG_PATH}/Klicky"
    fi

    cp -rf "${KLICKY_PATH}/Klicky" "${CONFIG_PATH}/Klicky"
    chmod 755 "${CONFIG_PATH}/Klicky"
    for FILE in "${CONFIG_PATH}/Klicky/*"; do
        chmod 644 $FILE
    done


    for OVERRIDE in ${OVERRIDES[@]}; do
        chmod -R 777 "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg"
        rm -R "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg"
        cp -rf "${KLICKY_PATH}/Overrides/override_${OVERRIDE}.cfg" "${CONFIG_PATH}/Overrides/override_${OVERRIDE}.cfg"
    done
    
    chmod 755 "${CONFIG_PATH}/Overrides"
    for FILE in "${CONFIG_PATH}/Overrides/*"; do
        chmod 644 $FILE
    done


    mkdir -p "${CONFIG_PATH}/Variables"
    for VARIABLE in ${VARIABLES[@]}; do
        if [ ! -f "${CONFIG_PATH}/Variables/${VARIABLE}_variables.cfg" ]; then
            cp -f "${KLICKY_PATH}/Variables/${VARIABLE}_variables.cfg" "${CONFIG_PATH}/Variables/${VARIABLE}_variables.cfg"
        else
            echo "${VARIABLE}-variables file already exists"
        fi
    done

    chmod 755 "${CONFIG_PATH}/Variables"
    for FILE in "${CONFIG_PATH}/Variables/*"; do
        chmod 644 $FILE
    done
}

function restart_klipper {
    echo "[POST-INSTALL] Restarting Klipper..."
    sudo systemctl restart klipper
}


printf "\n======================================\n"
echo "- Klicky install script -"
printf "======================================\n\n"


# Run steps
preflight_checks
check_download
link_extension
restart_klipper
