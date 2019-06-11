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
THEME_VARIANTS=('' '-red' '-pink' '-purple' '-blue' '-green' '-yellow' '-orange' '-brown' '-grey' '-black')
COLOR_VARIANTS=('' '-dark')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-c, --circle" "Install circle folder version"
  printf "  %-25s%s\n" "-all" "Install all color folder versions"
  printf "  %-25s%s\n" "-red" "Red color folder version"
  printf "  %-25s%s\n" "-pink" "Pink color folder version"
  printf "  %-25s%s\n" "-purple" "Purple color folder version"
  printf "  %-25s%s\n" "-blue" "Blue color folder version"
  printf "  %-25s%s\n" "-green" "Green color folder version"
  printf "  %-25s%s\n" "-yellow" "Yellow color folder version"
  printf "  %-25s%s\n" "-orange" "Orange color folder version"
  printf "  %-25s%s\n" "-brown" "Brown color folder version"
  printf "  %-25s%s\n" "-black" "Black color folder version"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local dest=${1}
  local name=${2}
  local color=${3}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                             ${THEME_DIR}
  cp -ur ${SRC_DIR}/COPYING                                                            ${THEME_DIR}
  cp -ur ${SRC_DIR}/AUTHORS                                                            ${THEME_DIR}
  cp -ur ${SRC_DIR}/src/index.theme                                                    ${THEME_DIR}

  cd ${THEME_DIR}
  sed -i "s/${name}/${name}${theme}${color}/g" index.theme

  if [[ ${color} == '' ]]; then
    cp -ur ${SRC_DIR}/src/{actions,animations,apps,categories,devices,emblems,mimes,places,status}  ${THEME_DIR}
    cp -r ${SRC_DIR}/links/{actions,apps,devices,emblems,mimes,places,status}                       ${THEME_DIR}
  fi

  if [[ ${color} == '' && ${theme} != '' ]]; then
    cp -r ${SRC_DIR}/colorful-folder/folder${theme}/*.svg                              ${THEME_DIR}/places/48
  fi

  if [[ ${circle} == 'true' && ${theme} == '' && ${color} == '' ]]; then
    cp -r ${SRC_DIR}/circle-folder/*.svg                                               ${THEME_DIR}/places/48
  fi

  if [[ ${color} == '-dark' ]]; then
    mkdir -p                                                                           ${THEME_DIR}/actions
    mkdir -p                                                                           ${THEME_DIR}/devices
    mkdir -p                                                                           ${THEME_DIR}/places
    mkdir -p                                                                           ${THEME_DIR}/status

    cp -ur ${SRC_DIR}/src/actions/{16,22,24}                                           ${THEME_DIR}/actions
    cp -ur ${SRC_DIR}/src/devices/16                                                   ${THEME_DIR}/devices
    cp -ur ${SRC_DIR}/src/places/16                                                    ${THEME_DIR}/places
    cp -ur ${SRC_DIR}/src/status/{16,22,24}                                            ${THEME_DIR}/status

    cd ${THEME_DIR}/actions/16 && sed -i "s/#565656/#dedede/g" `ls`
    cd ${THEME_DIR}/actions/22 && sed -i "s/#565656/#dedede/g" `ls`
    cd ${THEME_DIR}/actions/24 && sed -i "s/#565656/#dedede/g" `ls`
    cd ${THEME_DIR}/devices/16 && sed -i "s/#565656/#dedede/g" `ls`
    cd ${THEME_DIR}/places/16 && sed -i "s/#565656/#dedede/g" `ls`
    cd ${THEME_DIR}/status/16 && sed -i "s/#363636/#dedede/g" `ls`
    cd ${THEME_DIR}/status/22 && sed -i "s/#363636/#dedede/g" `ls`
    cd ${THEME_DIR}/status/24 && sed -i "s/#363636/#dedede/g" `ls`

    cp -ur ${SRC_DIR}/links/actions/{16,22,24}                                         ${THEME_DIR}/actions
    cp -ur ${SRC_DIR}/links/devices/16                                                 ${THEME_DIR}/devices
    cp -ur ${SRC_DIR}/links/places/16                                                  ${THEME_DIR}/places
    cp -ur ${SRC_DIR}/links/status/16                                                  ${THEME_DIR}/status

    cd ${dest}
    ln -s ../${name}${theme}/animations ${name}${theme}-dark/animations
    ln -s ../${name}${theme}/apps ${name}${theme}-dark/apps
    ln -s ../${name}${theme}/categories ${name}${theme}-dark/categories
    ln -s ../${name}${theme}/emblems ${name}${theme}-dark/emblems
    ln -s ../${name}${theme}/mimes ${name}${theme}-dark/mimes
    ln -s ../../${name}${theme}/actions/symbolic ${name}${theme}-dark/actions/symbolic
    ln -s ../../${name}${theme}/devices/symbolic ${name}${theme}-dark/devices/symbolic
    ln -s ../../${name}${theme}/devices/scalable ${name}${theme}-dark/devices/scalable
    ln -s ../../${name}${theme}/places/48 ${name}${theme}-dark/places/48
    ln -s ../../${name}${theme}/places/symbolic ${name}${theme}-dark/places/symbolic
    ln -s ../../${name}${theme}/status/32 ${name}${theme}-dark/status/32
    ln -s ../../${name}${theme}/status/symbolic ${name}${theme}-dark/status/symbolic

    cd ${THEME_DIR}
    sed -i "s/Numix-Circle-Light/Numix-Circle/g" index.theme
  fi

  cd ${dest}
  gtk-update-icon-cache ${name}${theme}${color}
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -c|--circle)
      circle='true'
      ;;
    -all)
      all="true"
      ;;
    -black)
      theme="-black"
      ;;
    -blue)
      theme="-blue"
      ;;
    -brown)
      theme="-brown"
      ;;
    -green)
      theme="-green"
      ;;
    -grey)
      theme="-grey"
      ;;
    -orange)
      theme="-orange"
      ;;
    -pink)
      theme="-pink"
      ;;
    -red)
      theme="-red"
      ;;
    -yellow)
      theme="-yellow"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
  shift
done

install_theme() {
  for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}"
  done
}

install_all() {
for theme in "${themes[@]-${THEME_VARIANTS[@]}}"; do
  for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}"
  done
done
}

if [[ "${all}" == 'true' ]]; then
  install_all
  else
  install_theme
fi
