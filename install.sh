#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=McMojave-circle
COLOR_VARIANTS=('' '-dark')

install() {
  local dest=${1}
  local name=${2}
  local color=${3}
  local THEME_DIR=${dest}/${name}${color}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  cp -ur ${SRC_DIR}/${name}${color}                                                    ${THEME_DIR}
  cp -ur ${SRC_DIR}/COPYING                                                            ${THEME_DIR}
  cp -ur ${SRC_DIR}/AUTHORS                                                            ${THEME_DIR}

#  cd ${dest}
#  gtk-update-icon-cache ${name}${color}
}

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}"
done

