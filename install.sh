#!/bin/bash

DOTFILES_REPO="https://github.com/mateussgubim/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"
PACKAGE_LIST="$DOTFILES_DIR/packages" 

echo -e "\033[1;33mStarting Arch configuration...\033[0m"

sudo pacman -Syu --needed --noconfirm base-devel git

if ! command -v paru &> /dev/null; then
    echo -e "\033[1;33mAUR helper 'paru' not found. Installing...\033[0m"
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/paru-bin.git "$TEMP_DIR"
    cd "$TEMP_DIR" && makepkg -si --noconfirm && cd - > /dev/null
    rm -rf "$TEMP_DIR"
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "\033[1;33mCloning dotfiles from $DOTFILES_REPO...\033[0m"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo -e "\033[1;33mDotfiles directory exists. Pulling changes...\033[0m"
    cd "$DOTFILES_DIR" && git pull && cd - > /dev/null
fi

echo -e "\033[1;33mDeploying configurations to $CONFIG_DIR...\033[0m"
mkdir -p "$CONFIG_DIR"

for dir in $(find "$DOTFILES_DIR" -maxdepth 1 -type d -not -path "*/.*" -not -path "$DOTFILES_DIR"); do
    folder_name=$(basename "$dir")
    target="$CONFIG_DIR/$folder_name"

    if [ -d "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}_bkp_$(date +%Y%m%d_%H%M%S)"
    fi

    if [ ! -L "$target" ]; then
        ln -s "$dir" "$target"
        echo "Linked $folder_name"
    fi
done

if [ -f "$PACKAGE_LIST" ]; then
    echo -e "\033[1;33mInstalling packages from $PACKAGE_LIST...\033[0m"
    sudo pacman -S --needed --noconfirm - < "$PACKAGE_LIST"
else
    echo -e "\033[1;31mWarning: $PACKAGE_LIST not found. Skipping installation.\033[0m"
fi

echo -e "\033[1;32mSetup complete! Log out and back in to see changes.\033[0m"
