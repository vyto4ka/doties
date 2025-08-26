#!/usr/bin/env bash
set -euo pipefail

get_layout() {
  # Пытаемся взять активную раскладку у основного девайса
  local layout
  layout="$(hyprctl -j devices 2>/dev/null | jq -r '
    ([.keyboards[] | select(.main==true) | (.active_keymap // .keymap // .layout)] |
     map(select(.!=null)) | .[0]) // empty
  ')"
  # Фолбэк: первая клавиатура, если "main" не найден
  if [ -z "$layout" ]; then
    layout="$(hyprctl -j devices 2>/dev/null | jq -r '
      (.keyboards[0].active_keymap // .keyboards[0].keymap // .keyboards[0].layout) // empty
    ')"
  fi
  # Ещё один фолбэк: хотя бы первая из input:kb_layout (не всегда верно для текущей, но лучше чем пусто)
  if [ -z "$layout" ]; then
    layout="$(hyprctl -j getoption input:kb_layout 2>/dev/null | jq -r '.str // empty' | cut -d, -f1 | xargs echo -n)"
  fi
  echo -n "$layout"
}

short() {
  case "$1" in
    *Russian*|ru|RU|*ru*) echo "RU" ;;
    *US*|*English*|us|EN|*en*) echo "EN" ;;
    *Swedish*|se|SE|*sv*) echo "SE" ;;
    ""|null) echo "--" ;;
    *) echo "$1" ;;
  esac
}

if [ "${1:-}" = "toggle" ]; then
  # Берём имя основного девайса, иначе первого
  kb="$(hyprctl -j devices | jq -r '
    ([.keyboards[] | select(.main==true) | .name] + [.keyboards[0].name]) 
    | map(select(.!=null)) | .[0]
  ')"
  if [ -n "$kb" ]; then
    hyprctl switchxkblayout "$kb" next >/dev/null 2>&1 || true
    sleep 0.05
  fi
fi

short "$(get_layout)"
