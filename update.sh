#!/bin/bash

KLICKY_PATH="${HOME}/klicky"

function update_repo {
    cd ${KLICKY_PATH}
    git fetch origin
    if [ `git rev-list HEAD...origin/main --count` != 0 ]; then
        echo "[UPDATE] Updating Klicky repository..."
        if git pull origin; then
            printf "[UPDATE] Download complete!\n\n"
        else
            echo "[ERROR] Download of Klicky git repository failed!"
            exit -1
        fi
    else
        echo "[UPDATE] Repo already up to date."
        exit 0
    fi
}

function install {
    chmod +x ${KLICKY_PATH}/install.sh
    bash ${KLICKY_PATH}/install.sh
}

update_repo
install
