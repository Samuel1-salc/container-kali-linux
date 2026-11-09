#!/usr/bin/env bash
set -u

echo '=== Identidade e capacidades disponíveis ==='
id
printf '\n=== Interfaces de rede (ip -br link) ===\n'
ip -br link || true
printf '\n=== Interfaces sem fio (iw dev) ===\n'
iw dev || true
printf '\n=== Modos suportados (iw list) ===\n'
if iw list > /tmp/iw-list.txt 2>/tmp/iw-error.txt; then
  sed -n '/Supported interface modes:/,/Band 1:/p' /tmp/iw-list.txt | head -40
else
  cat /tmp/iw-error.txt
  echo 'Não foi possível consultar capacidades Wi-Fi.'
fi
printf '\n=== Interfaces detectadas pelo airmon-ng ===\n'
airmon-ng || true
printf '\nAviso: modo monitor NÃO foi ativado automaticamente.\n'
