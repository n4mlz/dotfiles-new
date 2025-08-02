#!/bin/sh
set -euo pipefail

log() {
    printf '%s\n' "$*"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

run_as_root() {
    if [ "$(id -u)" -ne 0 ] && command_exists sudo; then
        sudo "$@"
    else
        "$@"
    fi
}

install_packages() {
    packages="$*"
    if command_exists apt-get; then
        log "Installing ${packages} via apt..."
        run_as_root apt-get update -y
        run_as_root apt-get install -y $packages
        return
    fi

    if command_exists pacman; then
        log "Installing ${packages} via pacman..."
        run_as_root pacman -Syu --noconfirm
        run_as_root pacman -S --needed --noconfirm $packages
        return
    fi

    log "Unsupported package manager; please install ${packages} manually." >&2
    exit 1
}

choose_bindir() {
    if printf '%s' "$PATH" | tr ':' '\n' | grep -qx "$HOME/.local/bin" && [ -d "$HOME/.local/bin" ]; then
        printf '%s' "$HOME/.local/bin"
    elif [ -d "$HOME/.local/bin" ] && [ -w "$HOME/.local/bin" ]; then
        printf '%s' "$HOME/.local/bin"
    else
        printf '%s' "/usr/local/bin"
    fi
}

ensure_command() {
    cmd="$1"
    shift
    if ! command_exists "$cmd"; then
        install_packages "$@"
    fi
}

# ---- main ----

log "Checking for curl and git..."
ensure_command curl curl git
ensure_command git curl git
log "done"

log "Checking for chezmoi installation..."
if ! command_exists chezmoi; then
    if command_exists pacman; then
        log "Installing chezmoi via pacman..."
        run_as_root pacman -S --needed --noconfirm chezmoi
    else
        BINDIR=$(choose_bindir)
        log "Installing chezmoi by downloading installer (target: $BINDIR)..."
        if [ "$BINDIR" = "/usr/local/bin" ]; then
            sudo env BINDIR="$BINDIR" sh -c 'curl -fsLS get.chezmoi.io | sh'
        else
            BINDIR="$BINDIR" sh -c 'curl -fsLS get.chezmoi.io | sh'
        fi
    fi
else
    log "chezmoi already installed."
fi
log "done"

log "Checking for dotfiles installation..."
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    log "Dotfiles not found. Initializing chezmoi..."
    chezmoi init n4mlz/dotfiles-new
else
    log "Dotfiles already initialized."
fi
log "done"

log "Applying dotfiles..."
chezmoi apply
log "Dotfiles applied successfully."
