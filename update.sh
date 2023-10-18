#!/bin/bash

KLICKY_PATH="${HOME}/klicky"

function update_repo {
    local klickydirname klickybasename
    klickydirname="$(dirname ${KLICKY_PATH})"
    klickybasename="$(basename ${KLICKY_PATH})"

    echo "[UPDATE] Updating Klicky repository..."
    cd ${KLICKY_PATH}
    if git pull origin; then
        printf "[UPDATE] Download complete!\n\n"
    else
        echo "[ERROR] Download of Klicky git repository failed!"
        exit -1
    fi
}

function install {
    chmod +x ${KLICKY_PATH}/install.sh
    bash ${KLICKY_PATH}/install.sh
}

update_repo
install
