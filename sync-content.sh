#!/usr/bin/env bash
# vault → quartz content 동기화.
# LoRA 개념노트는 공개 사이트에서 제외(vault 내부에는 유지)하고,
# 남은 문서의 해당 링크는 일반 텍스트로 바꿔 broken link를 방지한다.
set -e
Q="$(cd "$(dirname "$0")" && pwd)"
V="/home/adam/project_magent_tips/마젠트_기술_Vault"

# 1) 노트 동기화 (홈 index.md는 content 전용이라 보존)
find "$Q/content" -maxdepth 1 -name '*.md' ! -name 'index.md' -delete
cp "$V"/*.md "$Q/content/"

# 2) 첨부 동기화
rm -rf "$Q/content/attachments"
cp -r "$V/attachments" "$Q/content/attachments"

# 3) LoRA 개념노트는 공개 제외 (내부 vault에는 그대로 유지)
rm -f "$Q/content/"*개념_LoRA*.md

# 4) 남은 문서의 LoRA 개념노트 링크 → 일반 텍스트 (broken link 방지)
python3 - "$Q/content" <<'PY'
import re, glob, os, sys
d = sys.argv[1]
def strip(m):
    inner = m.group(1)
    return inner.split('|', 1)[1] if '|' in inner else 'LoRA/QLoRA 개념'
for f in glob.glob(os.path.join(d, '*.md')):
    s = open(f, encoding='utf-8').read()
    n = re.sub(r'\[\[([^\]]*개념_LoRA[^\]]*)\]\]', strip, s)
    if n != s:
        open(f, 'w', encoding='utf-8').write(n)
PY

echo "content 동기화 완료 (LoRA 개념노트 공개 제외)"
