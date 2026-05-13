#!/bin/bash
echo "🎨 Instalando rice Nord..."

# Fuentes
mkdir -p ~/.local/share/fonts
cp -r fonts/* ~/.local/share/fonts/ 2>/dev/null
fc-cache -fv

# Kvantum
sudo apt install -y qt6-style-kvantum
mkdir -p ~/.config/Kvantum
cp -r kvantum/Nordic ~/.config/Kvantum/

# Konsole
mkdir -p ~/.local/share/konsole
cp konsole/* ~/.local/share/konsole/
cp konsolerc ~/.config/

# Plasma
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r plasma/Nordic-darker ~/.local/share/plasma/look-and-feel/

# Zsh
cp .zshrc ~/
cp .p10k.zsh ~/

echo "✅ Rice Nord instalado. Reinicia sesión para aplicar todos los cambios."
