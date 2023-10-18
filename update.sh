#!/bin/bash


KLICKY_PATH="${HOME}/klicky"

local klickydirname klickybasename
klickydirname="$(dirname ${KLICKY_PATH})"
klickybasename="$(basename ${KLICKY_PATH})"

echo "[UPDATE] Upsating Klicky repository..."
cd ${KLICKY_PATH}
git pull origin
chmod +x ${KLICKY_PATH}/install.sh
  
printf "[UPDATE] Download complete!\n\n"

bash ${KLICKY_PATH}/install.sh
