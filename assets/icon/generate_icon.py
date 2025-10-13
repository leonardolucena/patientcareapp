#!/usr/bin/env python3
"""
Script para gerar o ícone do PatientCare App
Requer: pip install pillow
"""

from PIL import Image, ImageDraw

# Cores do app (mesmas do app_colors.dart)
PRIMARY_TEAL = (63, 120, 132)  # #3F7884
BACKGROUND = (255, 255, 255)

# Criar imagem 1024x1024
size = 1024
img = Image.new('RGB', (size, size), BACKGROUND)
draw = ImageDraw.Draw(img)

# Desenhar cruz de hospital (símbolo médico)
center = size // 2
cross_width = size // 3
cross_thickness = size // 6

# Barra vertical
draw.rectangle([
    center - cross_thickness // 2,
    center - cross_width // 2,
    center + cross_thickness // 2,
    center + cross_width // 2
], fill=PRIMARY_TEAL)

# Barra horizontal
draw.rectangle([
    center - cross_width // 2,
    center - cross_thickness // 2,
    center + cross_width // 2,
    center + cross_thickness // 2
], fill=PRIMARY_TEAL)

# Salvar
img.save('assets/icon/icon.png')
print('✅ Ícone gerado: assets/icon/icon.png')

