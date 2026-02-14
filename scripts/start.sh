#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "[+] Starting lab (build if needed)..."
docker compose up -d --build

echo "[+] Containers:"
docker compose ps

echo "[+] Try access:"
echo "    DVWA   -> http://localhost:8080"
echo "    S2-005 -> http://localhost:8081"
