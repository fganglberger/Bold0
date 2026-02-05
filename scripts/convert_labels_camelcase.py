#!/usr/bin/env python3
import re
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
STRINGS_PATH = ROOT / 'resources' / 'strings' / 'strings.xml'

def to_pascal_case(s: str) -> str:
    if not s:
        return s
    parts = re.findall(r"[A-Za-z0-9]+|[^A-Za-z0-9\s]+", s)
    out = []
    for p in parts:
        if re.match(r"[A-Za-z0-9]+", p):
            out.append(p.capitalize())
        else:
            out.append(p)
    return ''.join(out)

def main():
    if not STRINGS_PATH.exists():
        print(f"File not found: {STRINGS_PATH}")
        return

    # Backup
    bak = STRINGS_PATH.with_suffix('.xml.bak')
    if not bak.exists():
        bak.write_text(STRINGS_PATH.read_text(encoding='utf-8'), encoding='utf-8')

    tree = ET.parse(STRINGS_PATH)
    root = tree.getroot()

    changed = 0
    for elem in root.findall('string'):
        sid = elem.get('id','')
        if sid.startswith('LABEL_'):
            old = elem.text or ''
            new = to_pascal_case(old)
            if new != old:
                elem.text = new
                changed += 1

    if changed:
        tree.write(STRINGS_PATH, encoding='utf-8', xml_declaration=True)
        print(f"Updated {changed} LABEL_ entries in {STRINGS_PATH}")
    else:
        print("No LABEL_ entries changed")

if __name__ == '__main__':
    main()
