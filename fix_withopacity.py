import os
import re

# Chemin du projet
project_path = r"C:\Users\DELL\Desktop\workspace\SpeakUp\lib"

# Pattern pour remplacer withOpacity par withValues
def replace_withOpacity(content):
    # Remplacer .withOpacity(X) par .withValues(alpha: X)
    pattern = r'\.withOpacity\(([\d.]+)\)'
    replacement = r'.withValues(alpha: \1)'
    return re.sub(pattern, replacement, content)

# Parcourir tous les fichiers .dart
count = 0
for root, dirs, files in os.walk(project_path):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content = replace_withOpacity(content)
            
            if content != new_content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                count += 1
                print(f"✅ Corrigé: {filepath}")

print(f"\n🎉 {count} fichiers corrigés !")
