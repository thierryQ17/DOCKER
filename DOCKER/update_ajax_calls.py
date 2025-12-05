#!/usr/bin/env python3
"""Script pour remplacer tous les appels AJAX vers api.php"""

import re

file_path = r'www\Annuaire\maires.php'

# Lire le fichier
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Remplacements
replacements = [
    (r"ajax: 'getDepartements'", r"action: 'getDepartements'"),
    (r"ajax: 'getMaires'", r"action: 'getMaires'"),
    (r"ajax: 'getMaireDetails'", r"action: 'getMaireDetails'"),
    (r"ajax: 'getDemarchage'", r"action: 'getDemarchage'"),
    (r"ajax: 'getStatsDemarchage'", r"action: 'getStatsDemarchage'"),
    (r"ajax: 'autocompleteAdvanced'", r"action: 'autocompleteAdvanced'"),
    (r"fetch\('maires\.php\?", r"fetch('api.php?"),
    (r"fetch\(`maires\.php\?", r"fetch(`api.php?"),
    (r"formData\.append\('ajax',", r"formData.append('action',"),
    (r"maires\.php\?ajax=", r"api.php?action="),
]

# Appliquer les remplacements
for pattern, replacement in replacements:
    content = re.sub(pattern, replacement, content)

# Écrire le fichier
with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
    f.write(content)

print("✅ Tous les appels AJAX ont été mis à jour vers api.php")
