#!/bin/sh

as_root() {
    if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

echo "Checking default shell..."

if [ "$(getent passwd "$(id -un)" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    echo "Changing login shell to zsh..."
    USERNAME="$(id -un)"
    as_root chsh -s "$(command -v zsh)" "$USERNAME"
    echo "done"

    echo "Installation complete! Please run 'zsh' to start using it."
else
    echo "zsh is already the default shell."
fi
