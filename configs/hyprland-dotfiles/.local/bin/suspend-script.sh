#!/bin/bash

# Script para suspender o sistema de forma segura

# 1. Bloquear a tela antes de suspender
# Preferência para hyprlock, depois swaylock
if command -v hyprlock >/dev/null 2>&1; then
    hyprlock &
    sleep 1 # Pequeno delay para garantir o bloqueio
elif command -v swaylock >/dev/null 2>&1; then
    swaylock -f -c 000000 &
    sleep 1
fi

# 2. Suspender o sistema
systemctl suspend
