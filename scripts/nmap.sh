#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p samples

if ! command -v nmap >/dev/null 2>&1; then
  echo "[!] nmap not found. Install with: sudo apt update && sudo apt install -y nmap"
  exit 1
fi

echo "[+] Generating Nmap samples into ./samples"

# Full TCP scan (SYN scan needs sudo; fallback to -sT if you don't want sudo)
if sudo -n true 2>/dev/null; then
  sudo nmap -sS -sV -Pn -p- 127.0.0.1 -oN samples/case01_full_tcp.txt
else
  echo "[!] sudo needs password. Running -sT (no root) instead of -sS."
  nmap -sT -sV -Pn -p- 127.0.0.1 -oN samples/case01_full_tcp.txt
fi

nmap -sV -Pn -p 8080,8081 --script http-title,http-headers 127.0.0.1 \
  -oN samples/case02_web_fingerprint.txt

echo "[+] Done:"
ls -lh samples
