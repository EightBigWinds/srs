#!/usr/bin/env bash
set -euo pipefail

SOURCE_URL="https://static-file-global.353355.xyz/rules/cn-additional-list.txt"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORK_DIR="$ROOT_DIR/.work"
OUT_SOURCE_DIR="$ROOT_DIR/sing-box/source"
OUT_SRS_DIR="$ROOT_DIR/sing-box/srs"
SINGBOX_VERSION="1.13.8"
SINGBOX_URL="https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-amd64.tar.gz"

mkdir -p "$WORK_DIR" "$OUT_SOURCE_DIR" "$OUT_SRS_DIR"

TXT_TMP="$WORK_DIR/cn-additional-list.txt.tmp"
JSON_TMP="$WORK_DIR/cn-additional-list.json.tmp"
SRS_TMP="$WORK_DIR/cn-additional-list.srs.tmp"
TAR_PATH="$WORK_DIR/sing-box.tar.gz"
SINGBOX_DIR="$WORK_DIR/sing-box"
SINGBOX_BIN="$SINGBOX_DIR/sing-box"

curl -fsSL "$SOURCE_URL" -o "$TXT_TMP"

python3 - <<'PY' "$TXT_TMP" "$JSON_TMP"
import json, sys
src, dst = sys.argv[1], sys.argv[2]
with open(src, 'r', encoding='utf-8') as f:
    domains = [line.strip() for line in f if line.strip() and not line.lstrip().startswith('#')]
with open(dst, 'w', encoding='utf-8') as f:
    json.dump({"version": 3, "rules": [{"domain_suffix": domains}]}, f, ensure_ascii=False)
PY

if [ ! -x "$SINGBOX_BIN" ]; then
  rm -rf "$SINGBOX_DIR"
  mkdir -p "$SINGBOX_DIR"
  curl -fsSL "$SINGBOX_URL" -o "$TAR_PATH"
  tar -xzf "$TAR_PATH" -C "$SINGBOX_DIR" --strip-components=1
fi

"$SINGBOX_BIN" rule-set compile -o "$SRS_TMP" "$JSON_TMP"

mv -f "$TXT_TMP" "$OUT_SOURCE_DIR/cn-additional-list.txt"
mv -f "$JSON_TMP" "$OUT_SOURCE_DIR/cn-additional-list.json"
mv -f "$SRS_TMP" "$OUT_SRS_DIR/cn-additional-list.srs"

echo updated
