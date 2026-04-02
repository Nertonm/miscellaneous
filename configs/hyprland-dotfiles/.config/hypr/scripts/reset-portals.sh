#!/bin/bash
sleep 1
# Mata processos antigos
pkill -x xdg-desktop-portal-hyprland 2>/dev/null
pkill -x xdg-desktop-portal-gtk 2>/dev/null
pkill -x xdg-desktop-portal 2>/dev/null
pkill -x dunst 2>/dev/null

# Atualiza ambiente
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Inicia o Dunst primeiro
/usr/bin/dunst &
sleep 1

# Inicia portais na ordem correta
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 2
/usr/libexec/xdg-desktop-portal-gtk &
sleep 2
/usr/libexec/xdg-desktop-portal &
