#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=McMojave-circle
_THEME_VARIANTS=('' '-red' '-pink' '-purple' '-blue' '-green' '-yellow' '-orange' '-brown' '-grey' '-black')

if [ ! -z "${COMPA_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COMPA_VARIANTS <<< "${COMPA_VARIANTS:-}"
fi

if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes() {
for theme in "${_THEME_VARIANTS[@]}"; do
  rm -rf "${THEME_NAME}${theme}.tar.xz"
done

rm -rf "01-${THEME_NAME}.tar.xz"

for theme in "${_THEME_VARIANTS[@]}"; do
  tar -Jcvf "${THEME_NAME}${theme}.tar.xz" "${THEME_NAME}${theme}"{'','-light','-dark'}
done

mv "${THEME_NAME}.tar.xz" "01-${THEME_NAME}.tar.xz"
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[@]}"; do
  [[ -d "${THEME_NAME}${theme}" ]] && rm -rf "${THEME_NAME}${theme}"{'','-light','-dark'}
done
}

cd .. && ./install.sh -a -d $THEME_DIR

cd $THEME_DIR && Tar_themes && Clear_theme

