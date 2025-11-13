#!/usr/bin/env python3
"""
Create GitHub labels for BooksTrack Flutter project
"""

import subprocess

# Read labels from YAML
with open('.github/labels.yml', 'r') as f:
    content = f.read()

# Parse YAML manually (simple format)
labels = []
current_label = {}

for line in content.split('\n'):
    line = line.strip()
    if not line or line.startswith('#'):
        continue

    if line.startswith('- name:'):
        if current_label:
            labels.append(current_label)
        current_label = {'name': line.split('"')[1]}
    elif line.startswith('color:'):
        current_label['color'] = line.split('"')[1]
    elif line.startswith('description:'):
        current_label['description'] = line.split('"')[1]

if current_label:
    labels.append(current_label)

print(f"Creating {len(labels)} labels...")

for i, label in enumerate(labels, 1):
    try:
        cmd = [
            'gh', 'label', 'create',
            label['name'],
            '--color', label['color'],
            '--description', label['description'],
            '--force'
        ]
        subprocess.run(cmd, check=True, capture_output=True)
        print(f"✅ [{i}/{len(labels)}] {label['name']}")
    except subprocess.CalledProcessError as e:
        print(f"⚠️  [{i}/{len(labels)}] {label['name']} - {e.stderr.decode()}")

print(f"\n✅ Created {len(labels)} labels!")
