#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "[+] docker compose ps"
docker compose ps

echo
echo "[+] HTTP check"
curl -I http://127.0.0.1:8080 || true
echo "----"
curl -I http://127.0.0.1:8081 || true
