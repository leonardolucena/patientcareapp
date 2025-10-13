#!/bin/bash

# Script para criar ícone PNG a partir do SVG
# Usa o navegador Safari via screencapture ou qlmanage

echo "🎨 Gerando ícone do PatientCare App..."

# Método 1: Tentar com qlmanage (QuickLook)
if command -v qlmanage &> /dev/null; then
    echo "Usando qlmanage para converter SVG..."
    qlmanage -t -s 1024 -o assets/icon/ assets/icon/icon.svg
    if [ -f "assets/icon/icon.svg.png" ]; then
        mv assets/icon/icon.svg.png assets/icon/icon.png
        echo "✅ Ícone gerado: assets/icon/icon.png"
        exit 0
    fi
fi

# Método 2: Instruções para converter manualmente
echo "⚠️  Não foi possível converter automaticamente."
echo ""
echo "Por favor, converta manualmente usando uma destas opções:"
echo ""
echo "1️⃣  Online (recomendado):"
echo "   - Acesse: https://cloudconvert.com/svg-to-png"
echo "   - Upload: assets/icon/icon.svg"
echo "   - Tamanho: 1024x1024"
echo "   - Salve como: assets/icon/icon.png"
echo ""
echo "2️⃣  Photoshop/Figma/Sketch:"
echo "   - Abra assets/icon/icon.svg"
echo "   - Exporte como PNG 1024x1024"
echo "   - Salve em assets/icon/icon.png"
echo ""
echo "3️⃣  Instale ImageMagick:"
echo "   brew install imagemagick"
echo "   convert assets/icon/icon.svg -resize 1024x1024 assets/icon/icon.png"

