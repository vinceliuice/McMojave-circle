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
  printf "  %-25s%s\n" "-t, --theme VARIANTS..." "Specify theme color variant(s) [standard|red|pink|purple|blue|green|yellow|orange|brown|grey|black] (Default: All variants)"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

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

#  cd ${dest}
#  gtk-update-icon-cache ${name}${color}
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
      shift
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          standard)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          red)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          purple)
            colors+=("${THEME_VARIANTS[3]}")
            shift 1
            ;;
          blue)
            themes+=("${THEME_VARIANTS[4]}")
            shift 1
            ;;
          green)
            themes+=("${THEME_VARIANTS[5]}")
            shift 1
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[6]}")
            shift 1
            ;;
          orange)
            themes+=("${THEME_VARIANTS[7]}")
            shift 1
            ;;
          brown)
            themes+=("${THEME_VARIANTS[8]}")
            shift 1
            ;;
          grey)
            themes+=("${THEME_VARIANTS[9]}")
            shift 1
            ;;
          pink)
            themes+=("${THEME_VARIANTS[10]}")
            shift 1
            ;;
          black)
            themes+=("${THEME_VARIANTS[11]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
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
done

for theme in "${themes[@]-${THEME_VARIANTS[@]}}"; do
  for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
  done
done

