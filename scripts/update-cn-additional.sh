#!/usr/bin/env bash
set -euo pipefail

SOURCE_URL="https://static-file-global.353355.xyz/rules/cn-additional-list.txt"
UPSTREAM_JSON_URL="https://raw.githubusercontent.com/SukkaLab/ruleset.skk.moe/refs/heads/master/sing-box/non_ip/domestic.json"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORK_DIR="$ROOT_DIR/.work"
OUT_SOURCE_DIR="$ROOT_DIR/sing-box/source"
OUT_SRS_DIR="$ROOT_DIR/sing-box/srs"
SINGBOX_VERSION="1.13.8"
SINGBOX_URL="https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-amd64.tar.gz"

mkdir -p "$WORK_DIR" "$OUT_SOURCE_DIR" "$OUT_SRS_DIR"

TXT_TMP="$WORK_DIR/cn-additional-list.txt.tmp"
UPSTREAM_JSON_TMP="$WORK_DIR/domestic.json.tmp"
JSON_TMP="$WORK_DIR/cn-additional-list.json.tmp"
SRS_TMP="$WORK_DIR/cn-additional-list.srs.tmp"
TAR_PATH="$WORK_DIR/sing-box.tar.gz"
SINGBOX_DIR="$WORK_DIR/sing-box"
SINGBOX_BIN="$SINGBOX_DIR/sing-box"

curl -fsSL "$SOURCE_URL" -o "$TXT_TMP"
curl -fsSL "$UPSTREAM_JSON_URL" -o "$UPSTREAM_JSON_TMP"

python3 - <<'PY' "$TXT_TMP" "$UPSTREAM_JSON_TMP" "$JSON_TMP"
import json, sys
src_txt, upstream_json, dst = sys.argv[1], sys.argv[2], sys.argv[3]
seen = set()
domains = []

def add(value):
    value = value.strip()
    if not value or value.startswith('#') or value in seen:
        return
    seen.add(value)
    domains.append(value)

with open(src_txt, 'r', encoding='utf-8') as f:
    for line in f:
        add(line)

with open(upstream_json, 'r', encoding='utf-8') as f:
    data = json.load(f)
for rule in data.get('rules', []):
    for key in ('domain', 'domain_suffix'):
        for value in rule.get(key, []):
            add(value)

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
