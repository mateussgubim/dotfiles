#!/bin/bash

STYLE="$HOME/.config/wofi/style.css"

if pgrep -x "wofi" > /dev/null; then
    killall wofi
    exit 0
fi

entries=" Suspender\n󰑐 Reiniciar\n Desligar\n󰍃 Sair"

# No Debian, usamos apenas as flags estáveis.
# Adicionamos --search_text para o wofi não tentar filtrar o que você digita
selected=$(echo -e "$entries" | wofi --dmenu \
    --cache-file /dev/null \
    --location 3 \
    --xoffset -15 \
    --yoffset 45 \
    --width 200 \
    --height 190 \
    --style "$HOME/.config/wofi/style.css" \
    --hide-scroll \
    --no-actions \
    --define "entry_search_display=none")

case $selected in
  *Suspender) systemctl suspend ;;
  *Reiniciar) systemctl reboot ;;
  *Desligar) systemctl poweroff ;;
  *Sair) swaymsg exit ;;
esac
