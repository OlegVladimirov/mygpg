#!/bin/bash
# Simple smoke test — requires mygpg to be sourced first

if ! declare -f mygpg >/dev/null; then
  echo "❌ ERROR: 'mygpg' function not found. Run: source mygpg.sh"
  exit 1
fi

echo "Testing pipeline: echo 'ok' | mygpg -e | mygpg -d"
echo "ok" | MYGPGPAS=111 mygpg -e | MYGPGPAS=111 mygpg -d | grep -q "ok" && echo "✅ OK" || echo "❌ FAIL"