#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "[+] Stopping lab..."
docker compose down --remove-orphans

echo "[+] Done."
