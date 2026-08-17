import re
import sys

def extract_positions(tscn_path, output_path):
    with open(tscn_path, 'r', encoding='utf-8') as f:
        text = f.read()
        
    # Find all nodes like:
    # [node name="STARTING_GEMS" ...
    # position = Vector2(-64, -256)
    # upgrade_name = "STARTING_GEMS"
    
    nodes = re.findall(r'\[node name="([^"]+)"[^\]]*\](?:(?!\[node).)*?upgrade_name = "([^"]+)"(?:(?!\[node).)*', text, re.DOTALL)
    
    positions = {}
    
    # Actually, it's easier to split by [node
    blocks = text.split('[node ')
    for block in blocks:
        if 'upgrade_name =' in block:
            name_match = re.search(r'upgrade_name = "([^"]+)"', block)
            if name_match:
                name = name_match.group(1).lower()
                pos_match = re.search(r'position = Vector2\(([^,]+),\s*([^)]+)\)', block)
                if pos_match:
                    x, y = pos_match.group(1), pos_match.group(2)
                    positions[name] = (float(x), float(y))
                else:
                    positions[name] = (0.0, 0.0) # Default position
                    
    dart_code = """// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flame/components.dart';
import 'upgrades.dart';

final Map<Upgrade, Vector2> upgradePositions = {
"""
    for name, (x, y) in positions.items():
        dart_code += f"  Upgrade.{name}: Vector2({x}, {y}),\n"
        
    dart_code += "};\n"
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(dart_code)
        
    print(f"Successfully generated {output_path}")

if __name__ == "__main__":
    tscn_path = sys.argv[1]
    output_path = sys.argv[2]
    extract_positions(tscn_path, output_path)
