#!/bin/bash

# Variáveis de caminhos
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR="$HOME/.config"

# --- 1. Definição dos Grupos de Pacotes (Baseado no seu código) ---

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

# --- 3. Configuração de Teclado e Localização ---

echo "--- Configurando Teclado Global (US-Intl) ---"
# Isso garante que o teclado funcione corretamente no terminal e no Sway
sudo localectl set-x11-keymap us pc105 intl

# --- 4. Automação do Login (Início Automático do Sway) ---

echo "--- Configurando Auto-start do Sway no .bashrc ---"
if ! grep -q "exec sway" ~/.bashrc; then
    cat <<EOF >> ~/.bashrc

# Iniciar o Sway automaticamente no TTY1 (Login via terminal)
if [ -z "\${DISPLAY}" ] && [ "\${XDG_VTNR}" -eq 1 ]; then
  exec sway
fi
EOF
fi

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
