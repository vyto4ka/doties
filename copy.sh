#!/usr/bin/env bash
set -euo pipefail

FOLDERS=(
  "hypr"
  "waybar"
  "alacritty"
  "kitty"
  "fastfetch"
  "mako"
  "wallpaper"
  "wlogout"
  "wofi"
)

SRC="${HOME}/.config"
DST="$(pwd)"

for dir in "${FOLDERS[@]}"; do
  from="${SRC}/${dir}"
  to="${DST}/${dir}"

  if [[ -d "$from" ]]; then
    rm -rf -- "$to"
    cp -a -- "$from" "$to"
    echo "Копировано: ${dir}"
  else
    echo "Пропущено (нет в ~/.config): ${dir}" >&2
  fi
done
