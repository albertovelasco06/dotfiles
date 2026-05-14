# 🎨 Dotfiles — Nord Rice (Kubuntu)

![Nord](https://img.shields.io/badge/Theme-Nord-88C0D0?style=flat-square)
![KDE](https://img.shields.io/badge/DE-KDE%20Plasma%206-1d99f3?style=flat-square)
![Kubuntu](https://img.shields.io/badge/OS-Kubuntu%2026.04-E95420?style=flat-square)

## 📸 Componentes

| Elemento | Herramienta |
|---|---|
| OS | Kubuntu 26.04 |
| DE | KDE Plasma 6 |
| Tema global | Nordic-darker |
| Motor Qt | Kvantum + Nordic |
| Terminal | Konsole |
| Shell | Zsh + Oh-my-zsh |
| Prompt | Powerlevel10k |
| Editor | Neovim |
| Fuente | JetBrainsMono Nerd Font |
| Iconos | Papirus-Dark |
| Cursor | Nordic |
| Wallpaper | Nord Mountain |

## 🚀 Instalación automática

    git clone git@github.com:albertovelasco06/dotfiles.git
    cd dotfiles
    ./install.sh

## 📁 Estructura

    dotfiles/
    ├── .zshrc
    ├── .p10k.zsh
    ├── konsolerc
    ├── install.sh
    ├── konsole/
    │   ├── Nord.colorscheme
    │   └── Nord.profile
    ├── kvantum/
    │   └── Nordic/
    ├── nvim/
    │   └── init.lua
    ├── plasma/
    │   ├── Nordic-darker/
    │   └── panels/
    └── wallpapers/
        └── ign_mountain.png

## 🎨 Paleta Nord

| Color | Hex | Uso |
|---|---|---|
| Nord0 | #2E3440 | Fondo principal |
| Nord1 | #3B4252 | Fondo secundario |
| Nord4 | #D8DEE9 | Texto principal |
| Nord8 | #88C0D0 | Azul claro Frost |
| Nord11 | #BF616A | Rojo Aurora |
| Nord14 | #A3BE8C | Verde Aurora |

## 📦 Dependencias

    sudo apt install zsh qt6-style-kvantum papirus-icon-theme fastfetch

## 🔧 Pasos manuales tras instalar

1. Aplicar tema global → Nordic-darker
2. Aplicar estilo Qt → kvantum-dark
3. Aplicar iconos → Papirus-Dark
4. Aplicar cursor → Nordic
5. Abrir nvim → lazy.nvim instala los plugins solo
