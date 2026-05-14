#!/bin/bash

# =============================================================================
# Rice Nord - Script de instalación automática
# github.com/albertovelasco06/dotfiles
# =============================================================================

set -e  # Parar si hay algún error

# Colores para el output (usando la paleta Nord)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Directorio del script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()     { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

echo ""
echo "=================================================="
echo "   🎨 Rice Nord - Instalación automática"
echo "   Kubuntu + KDE Plasma 6"
echo "=================================================="
echo ""

# ------------------------------------------------------------------------------
# 1. DEPENDENCIAS BASE
# ------------------------------------------------------------------------------
log "Instalando dependencias base..."
sudo apt update -qq
sudo apt install -y \
  zsh wget curl git unzip \
  qt6-style-kvantum \
  papirus-icon-theme \
  fastfetch \
  2>/dev/null
success "Dependencias instaladas"

# ------------------------------------------------------------------------------
# 2. FUENTES - JetBrainsMono Nerd Font
# ------------------------------------------------------------------------------
log "Instalando JetBrainsMono Nerd Font..."
if fc-list | grep -q "JetBrainsMono"; then
  warning "JetBrainsMono ya está instalada, saltando..."
else
  mkdir -p ~/.local/share/fonts
  cd /tmp
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -q JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
  fc-cache -fv > /dev/null 2>&1
  success "JetBrainsMono Nerd Font instalada"
fi

# ------------------------------------------------------------------------------
# 3. KVANTUM - Tema Nordic
# ------------------------------------------------------------------------------
log "Configurando Kvantum con tema Nordic..."
mkdir -p ~/.config/Kvantum
if [ -d "$DOTFILES_DIR/kvantum/Nordic" ]; then
  cp -r "$DOTFILES_DIR/kvantum/Nordic" ~/.config/Kvantum/
  success "Tema Nordic copiado a Kvantum"
else
  warning "Carpeta kvantum/Nordic no encontrada en dotfiles"
fi

# ------------------------------------------------------------------------------
# 4. PLASMA - Tema Nordic-darker
# ------------------------------------------------------------------------------
log "Instalando tema Nordic-darker en Plasma..."
mkdir -p ~/.local/share/plasma/look-and-feel
if [ -d "$DOTFILES_DIR/plasma/Nordic-darker" ]; then
  cp -r "$DOTFILES_DIR/plasma/Nordic-darker" ~/.local/share/plasma/look-and-feel/
  # Crear metadata.json para Plasma 6
  cat > ~/.local/share/plasma/look-and-feel/Nordic-darker/metadata.json << 'JSON'
{
    "KPlugin": {
        "Authors": [{ "Email": "eliver.lara@gmail.com", "Name": "Eliver Lara" }],
        "Description": "Nordic Darker - A dark theme using the Nord color palette",
        "Id": "Nordic-darker",
        "License": "GPL-3.0",
        "Name": "Nordic Darker",
        "Version": "2.2.0",
        "Website": "https://github.com/EliverLara/Nordic"
    },
    "KPackageStructure": "Plasma/LookAndFeel"
}
JSON
  kbuildsycoca6 --noincremental > /dev/null 2>&1
  success "Tema Nordic-darker instalado"
else
  warning "Carpeta plasma/Nordic-darker no encontrada en dotfiles"
fi

# ------------------------------------------------------------------------------
# 5. KONSOLE - Perfil y esquema Nord
# ------------------------------------------------------------------------------
log "Configurando Konsole con esquema Nord..."
mkdir -p ~/.local/share/konsole
if [ -d "$DOTFILES_DIR/konsole" ]; then
  cp "$DOTFILES_DIR/konsole/"* ~/.local/share/konsole/
fi
if [ -f "$DOTFILES_DIR/konsolerc" ]; then
  cp "$DOTFILES_DIR/konsolerc" ~/.config/
fi
success "Konsole configurada"

# ------------------------------------------------------------------------------
# 6. ZSH + OH-MY-ZSH + POWERLEVEL10K
# ------------------------------------------------------------------------------
log "Instalando Oh-my-zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  warning "Oh-my-zsh ya está instalado, saltando..."
else
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
  success "Oh-my-zsh instalado"
fi

log "Instalando Powerlevel10k..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  warning "Powerlevel10k ya está instalado, saltando..."
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  success "Powerlevel10k instalado"
fi

log "Instalando plugins de zsh..."
# Autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
# Syntax highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
success "Plugins instalados"

log "Copiando configuración de zsh..."
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
  cp "$DOTFILES_DIR/.zshrc" ~/
fi
if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
  cp "$DOTFILES_DIR/.p10k.zsh" ~/
fi

# Cambiar shell por defecto a zsh
if [ "$SHELL" != "/bin/zsh" ]; then
  chsh -s $(which zsh)
  success "Shell cambiada a zsh"
fi

# ------------------------------------------------------------------------------
# 7. NEOVIM
# ------------------------------------------------------------------------------
log "Instalando Neovim..."
if command -v nvim &> /dev/null; then
  warning "Neovim ya está instalado ($(nvim --version | head -1)), saltando..."
else
  sudo add-apt-repository -y ppa:neovim-ppa/unstable > /dev/null 2>&1
  sudo apt update -qq
  sudo apt install -y neovim
  success "Neovim instalado"
fi

log "Configurando Neovim con tema Nord..."
mkdir -p ~/.config/nvim
if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
  cp "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/
  success "Configuración de Neovim copiada"
fi

# ------------------------------------------------------------------------------
# 8. WALLPAPER
# ------------------------------------------------------------------------------
log "Instalando wallpaper Nord..."
mkdir -p ~/.local/share/wallpapers/Nord
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
  cp "$DOTFILES_DIR/wallpapers/"* ~/.local/share/wallpapers/Nord/
  success "Wallpapers copiados"
fi

# ------------------------------------------------------------------------------
# 9. ICONOS - Papirus-Dark
# ------------------------------------------------------------------------------
log "Configurando iconos Papirus-Dark..."
if [ -d "/usr/share/icons/Papirus-Dark" ]; then
  success "Papirus-Dark ya está instalado"
else
  warning "Instala papirus-icon-theme manualmente si no aparece"
fi

# ------------------------------------------------------------------------------
# RESUMEN FINAL
# ------------------------------------------------------------------------------
echo ""
echo "=================================================="
echo -e "   ${GREEN}✅ Instalación completada${NC}"
echo "=================================================="
echo ""
echo "Pasos manuales pendientes:"
echo "  1. Abre Configuración del sistema y aplica:"
echo "     · Tema global    → Nordic-darker"
echo "     · Estilo Qt      → kvantum-dark"
echo "     · Iconos         → Papirus-Dark"
echo "     · Cursor         → Nordic"
echo "  2. Abre Konsole → carga el perfil Nord"
echo "  3. Abre nvim → lazy.nvim instalará los plugins solo"
echo ""
echo "  🎨 Rice Nord listo para usar"
echo ""
