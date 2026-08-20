"""Convert Godot upgrades.gd enums/map into Dart.

Live catalog is split across lib/models/upgrade_ids.dart,
lib/models/upgrades/*.dart, and lib/models/upgrades.dart.
This script still emits a single map; port new entries into the
category files instead of overwriting the merged catalog.
"""

import os
import re
import sys

def parse_enum(text, enum_name):
    pattern = r'enum\s+' + enum_name + r'\s*\{([^}]*)\}'
    match = re.search(pattern, text)
    if not match:
        return []
    
    body = match.group(1)
    body = re.sub(r'#.*', '', body)
    
    items = []
    for line in body.split(','):
        line = line.strip()
        if line:
            items.append(line)
    return items

def extract_upgrades_dict_string(text):
    start_str = "var upgrades = {"
    start_idx = text.find(start_str)
    if start_idx == -1:
        return ""
    
    brace_count = 0
    in_string = False
    escape = False
    
    for i in range(start_idx + len(start_str) - 1, len(text)):
        char = text[i]
        if escape:
            escape = False
            continue
        
        if char == '\\':
            escape = True
        elif char == '"':
            in_string = not in_string
        elif not in_string:
            if char == '{':
                brace_count += 1
            elif char == '}':
                brace_count -= 1
                if brace_count == 0:
                    return text[start_idx:i+1]
    return ""

def convert_to_dart(upgrades_gd_path, output_path):
    with open(upgrades_gd_path, 'r', encoding='utf-8') as f:
        text = f.read()

    activation_levels = parse_enum(text, 'ActivationLevel')
    tags = parse_enum(text, 'Tag')
    keywords = parse_enum(text, 'Keyword')
    value_formats = parse_enum(text, 'ValueFormat')
    upgrades = parse_enum(text, 'Upgrade')
    
    dart_code = """// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/foundation.dart';
import 'upgrade_data.dart';

enum ActivationLevel {
"""
    for item in activation_levels:
        dart_code += f"  {item.lower()},\n"
    dart_code += "}\n\n"
    
    dart_code += "enum Tag {\n"
    for item in tags:
        dart_code += f"  {item.lower()},\n"
    dart_code += "}\n\n"

    dart_code += "enum Keyword {\n"
    for item in keywords:
        dart_code += f"  {item.lower()},\n"
    dart_code += "}\n\n"

    dart_code += "enum ValueFormat {\n"
    for item in value_formats:
        dart_code += f"  {item.lower()},\n"
    dart_code += "}\n\n"

    dart_code += "enum Upgrade {\n"
    for item in upgrades:
        dart_code += f"  {item.lower()},\n"
    dart_code += "}\n\n"
    
    upgrades_dict_str = extract_upgrades_dict_string(text)
    
    upgrades_dict_str = re.sub(r'^\t\tUpgrade\.', '\tUpgrade.', upgrades_dict_str, flags=re.MULTILINE)
    upgrades_dict_str = re.sub(r'^\t{3}(max_level|cost|cost_token|icon|dependency|value|is_milestone|is_artifact|required_completed_level|data|tags|keywords)\b', r'\t\t\1', upgrades_dict_str, flags=re.MULTILINE)
    
    for upgrade in upgrades:
        upgrades_dict_str = re.sub(r'Upgrade\.' + upgrade + r'\s*:', f'Upgrade.{upgrade.lower()}:', upgrades_dict_str)
    
    upgrades_dict_str = upgrades_dict_str.replace('var upgrades = {', 'final Map<Upgrade, UpgradeData> upgradesMap = {')
    
    upgrades_dict_str = re.sub(r'(Upgrade\.[a-z0-9_]+):\s*\{', r'\1: UpgradeData(', upgrades_dict_str)
    
    lines = upgrades_dict_str.split('\n')
    new_lines = []
    for line in lines:
        if re.match(r'^\t\},?\s*$', line):
            line = line.replace('}', ')')
        
        line = re.sub(r'^\t\tmax_level\s*=', '\t\tmaxLevel:', line)
        line = re.sub(r'^\t\tcost\s*=', '\t\tcost:', line)
        line = re.sub(r'^\t\tcost_token\s*=', '\t\tcostToken:', line)
        line = re.sub(r'^\t\tvalue\s*=', '\t\tvalue:', line)
        line = re.sub(r'^\t\tvalue_format\s*=', '\t\tvalueFormat:', line)
        line = re.sub(r'^\t\ticon\s*=', '\t\ticonPath:', line)
        line = re.sub(r'^\t\tactivation_level\s*=', '\t\tactivationLevel:', line)
        line = re.sub(r'^\t\ttags\s*=', '\t\ttags:', line)
        line = re.sub(r'^\t\tdependency\s*=', '\t\tdependency:', line)
        line = re.sub(r'^\t\tdata\s*=', '\t\tdata:', line)
        line = re.sub(r'^\t\tis_milestone\s*=', '\t\tisMilestone:', line)
        line = re.sub(r'^\t\tis_artifact\s*=', '\t\tisArtifact:', line)
        line = re.sub(r'^\t\tkeywords\s*=', '\t\tkeywords:', line)
        line = re.sub(r'^\t\tdynamic_cost\s*=', '\t\tdynamicCost:', line)
        line = re.sub(r'^\t\trequired_completed_level\s*=', '\t\trequiredCompletedLevel:', line)
        line = re.sub(r'^\t\tdefault_unlocked_on_mobile\s*=', '\t\tdefaultUnlockedOnMobile:', line)
        line = re.sub(r'^\t\tavailable_in_demo\s*=', '\t\tavailableInDemo:', line)
        
        line = re.sub(r'^(\t{3,})([a-zA-Z0-9_]+)\s*=', r"\1'\2':", line)
        
        line = re.sub(r'func\s*\(\s*l\s*:\s*int\s*\)\s*:\s*return\s+(.*)', r'(int l) => \1', line)
        line = re.sub(r'func\s*\(\s*_l\s*:\s*int\s*\)\s*:\s*return\s+(.*)', r'(int _l) => \1', line)
        line = re.sub(r'func\s*\(\s*\)\s*:\s*return\s+(.*)', r'() => \1', line)
        
        def replace_preload(m):
            path = m.group(1)
            filename = path.split('/')[-1]
            return f"'assets/sprites/{filename}'"
        line = re.sub(r'preload\("([^"]+)"\)', replace_preload, line)
        
        line = re.sub(r'Tokens\.Types\.([A-Z0-9_]+)', lambda m: f"'{m.group(1).lower()}'", line)
        line = re.sub(r'ActivationLevel\.([A-Z0-9_]+)', lambda m: f"ActivationLevel.{m.group(1).lower()}", line)
        line = re.sub(r'Tag\.([A-Z0-9_]+)', lambda m: f"Tag.{m.group(1).lower()}", line)
        line = re.sub(r'Upgrade\.([A-Z0-9_]+)', lambda m: f"Upgrade.{m.group(1).lower()}", line)
        line = re.sub(r'ValueFormat\.([A-Z0-9_]+)', lambda m: f"ValueFormat.{m.group(1).lower()}", line)
        line = re.sub(r'Keyword\.([A-Z0-9_]+)', lambda m: f"Keyword.{m.group(1).lower()}", line)
        
        new_lines.append(line)
        
    upgrades_dict_str = '\n'.join(new_lines)
    
    if upgrades_dict_str.endswith(')'):
        upgrades_dict_str = upgrades_dict_str[:-1] + '};'
    elif upgrades_dict_str.endswith(');'):
        upgrades_dict_str = upgrades_dict_str[:-2] + '};'
    
    dart_code += upgrades_dict_str
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(dart_code)
    
    print(f"Successfully generated {output_path}")

if __name__ == "__main__":
    gd_path = sys.argv[1]
    dart_path = sys.argv[2]
    convert_to_dart(gd_path, dart_path)
