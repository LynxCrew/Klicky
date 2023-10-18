#!/bin/bash

KLICKY_PATH="${HOME}/klicky"

local klickydirname klickybasename
klickydirname="$(dirname ${KLICKY_PATH})"
klickybasename="$(basename ${KLICKY_PATH})"

echo "[DOWNLOAD] Downloading Klicky repository..."
if git -C $klickydirname clone https://github.com/LynxCrew/Klicky.git $klickybasename; then
  chmod +x ${KLICKY_PATH}/install.sh
  printf "[DOWNLOAD] Download complete!\n\n"

  bash ${KLICKY_PATH}/install.sh
else
  echo "[ERROR] Download of Klicky git repository failed!"
  exit -1
fi
