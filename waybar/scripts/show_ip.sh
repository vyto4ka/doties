#!/usr/bin/env bash
IP4="$(hostname -I 2>/dev/null | awk '{print $1}')"
[ -z "$IP4" ] && IP4="нет IPv4"
notify-send "Ваш IP" "$IP4"