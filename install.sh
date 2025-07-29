#!/bin/sh

as_root() {
    if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

install_with_apt() {
    as_root apt-get update -y
    as_root apt-get install -y curl git
}

install_with_pacman() {
    as_root pacman -Syu --noconfirm
    as_root pacman -S --needed --noconfirm curl git
}

choose_bindir() {
    if printf '%s\n' "$PATH" | tr ':' '\n' | grep -qx "$HOME/.local/bin"; then
        echo "$HOME/.local/bin"
    else
        echo "/usr/local/bin"
    fi
}

# install curl and git

echo "Checking for curl and git installation..."

if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        echo "Installing curl and git using apt..."
        install_with_apt
    elif command -v pacman >/dev/null 2>&1; then
        echo "Installing curl and git using pacman..."
        install_with_pacman
    else
        echo "Unsupported package manager. Please install curl and git manually."
        exit 1
    fi
fi

echo "done"

# install chezmoi

echo "Checking for chezmoi installation..."

if ! command -v chezmoi >/dev/null 2>&1; then
    if command -v pacman >/dev/null 2>&1; then
        echo "Installing chezmoi using pacman..."
        as_root pacman -S --needed --noconfirm chezmoi
    else
        BINDIR="$(choose_bindir)"
        echo "Installing chezmoi by downloading the binary... (installing to: $BINDIR)"
        BINDIR="$BINDIR" sh -c "$(curl -fsLS get.chezmoi.io)"
    fi
fi

echo "done"

# install dotfiles

echo "Checking for dotfiles installation..."

if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "Dotfiles not found. Initializing chezmoi..."
    chezmoi init n4mlz/dotfiles-new
fi

echo "done"

echo "Applying dotfiles..."

chezmoi apply

echo "Dotfiles applied successfully."
