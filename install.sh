#!/bin/bash

# Variáveis de caminhos
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR="$HOME/.config"

# --- 1. Definição dos Grupos de Pacotes ---

PACKAGES_CORE=(
    sway swayidle gtklock swaybg waybar
    xwayland build-essential
)

PACKAGES_SWAY=(
    wofi foot sway-notification-center autotiling
    grim slurp wl-clipboard cliphist
    brightnessctl playerctl
    wlr-randr xdg-desktop-portal-wlr swappy
)

PACKAGES_UI=(
    nwg-look network-manager-gnome lxpolkit
)

PACKAGES_FILE_MANAGER=(
    thunar thunar-archive-plugin thunar-volman
    gvfs gvfs-backends mtools unzip
)

PACKAGES_AUDIO=(
    pavucontrol pulsemixer pipewire-pulse wireplumber
)

PACKAGES_UTILITIES=(
    xdg-user-dirs swayimg zathura
    libnotify-bin curl wget git
)

PACKAGES_FONTS=(
    fonts-font-awesome fonts-jetbrains-mono fonts-noto-color-emoji
)

# Junção de todos os pacotes
all_packages=(
    "${PACKAGES_CORE[@]}" "${PACKAGES_SWAY[@]}" "${PACKAGES_UI[@]}"
    "${PACKAGES_FILE_MANAGER[@]}" "${PACKAGES_AUDIO[@]}" 
    "${PACKAGES_UTILITIES[@]}" "${PACKAGES_FONTS[@]}"
)

# --- 2. Execução da Instalação ---

echo "--- Atualizando Sistema ---"
sudo apt update && sudo apt upgrade -y

echo "--- Instalando Pacotes Selecionados ---"
sudo apt install -y ${all_packages[*]}

# --- 3. Configuração de Teclado Global ---

echo "--- Configurando Teclado Global (US-Intl) ---"
sudo localectl set-x11-keymap us pc105 intl

# --- 4. Automação do Login (Início Automático do Sway) ---

echo "--- Configurando Auto-start no .profile ---"

# Criamos um backup do .profile por segurança
[ -f ~/.profile ] && cp ~/.profile ~/.profile.bak

# Adicionando as instruções ao final do .profile
# Note que $DOTFILES_DIR será substituído pelo caminho real durante a execução
cat <<EOF >> ~/.profile

# --- Início das configurações do script de dotfiles ---
if [ -n "\$BASH_VERSION" ]; then
    if [ -f "$DOTFILES_DIR/.bashrc" ]; then
        . "$DOTFILES_DIR/.bashrc"
    fi
fi

if [ -z "\${DISPLAY}" ] && [ "\${XDG_VTNR}" -eq 1 ]; then
    exec sway
fi
# --- Fim das configurações do script de dotfiles ---
EOF

# --- 5. Criação de Links Simbólicos ---

echo "--- Aplicando Links Simbólicos ---"
mkdir -p "$CONFIG_DIR"

# Lista de pastas para linkar
folders=("sway" "waybar" "wofi" "foot" "zathura")

for folder in "${folders[@]}"; do
    if [ -d "$DOTFILES_DIR/$folder" ]; then
        rm -rf "$CONFIG_DIR/$folder"
        ln -sfn "$DOTFILES_DIR/$folder" "$CONFIG_DIR/$folder"
        echo "✔ $folder linkado."
    fi
done

# Permissão para o menu do Wofi
[ -f "$CONFIG_DIR/wofi/wofi-menu.sh" ] && chmod +x "$CONFIG_DIR/wofi/wofi-menu.sh"

echo "---------------------------------------------------"
echo "Setup Concluído!"
echo "---------------------------------------------------"
