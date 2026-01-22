#!/bin/bash

# Variáveis de caminhos
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG_DIR="$HOME/.config"

echo "--- 1. Atualizando o Sistema ---"
sudo apt update && sudo apt upgrade -y

echo "--- 2. Instalando Pacotes ---"
sudo apt install -y sway waybar foot wofi thunar gvfs tumbler thunar-archive-plugin thunar-volman swayimg zathura grim slurp wl-clipboard blueman bluez pipewire-pulse wireplumber brightnessctl playerctl fonts-jetbrains-mono policykit-1-gnome network-manager-gnome

# Instalando SDDM
sudo apt install -y sddm

sudo mkdir -p /etc/sddm.conf.d
sudo bash -c 'cat <<EOF > /etc/sddm.conf.d/wayland.conf
[General]
DisplayServer=wayland
EOF'

echo "--- 4. Aplicando Links Simbólicos (Dotfiles) ---"
mkdir -p "$CONFIG_DIR"

declare -A DOTFILES=(
    ["sway"]="$CONFIG_DIR/sway"
    ["waybar"]="$CONFIG_DIR/waybar"
    ["wofi"]="$CONFIG_DIR/wofi"
    ["zathura"]="$CONFIG_DIR/zathura"
    ["foot"]="$CONFIG_DIR/foot"
)

for folder in "${!DOTFILES[@]}"; do
    TARGET="${DOTFILES[$folder]}"
    SOURCE="$DOTFILES_DIR/$folder"
    rm -rf "$TARGET"
    ln -sfn "$SOURCE" "$TARGET"
    echo "✔ Linkado: $SOURCE -> $TARGET"
done

# Link para o .bashrc
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

echo "--- 5. Ajustando Permissões de Scripts ---"
if [ -f "$DOTFILES_DIR/wofi/wofi-menu.sh" ]; then
    chmod +x "$DOTFILES_DIR/wofi/wofi-menu.sh"
    echo "✔ Permissão concedida ao wofi-menu.sh"
fi

echo "--- 6. Ativando Serviços ---"
sudo systemctl enable bluetooth

echo "---------------------------------------------------"
echo "Setup Concluído!"
echo "Reinicie o sistema para testar."
echo "---------------------------------------------------"
