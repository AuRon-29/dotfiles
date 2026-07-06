# dotfiles

## Installation sur une machine neuve (Arch Linux)

1. Installer Arch (voir mon guide d'install perso)
2. `sudo pacman -S --needed git base-devel`
3. `git clone https://github.com/TON_PSEUDO/dotfiles.git ~/dotfiles`
4. `cd ~/dotfiles && ./install.sh`

## Structure
- `packages/` — listes pacman/AUR/services capturées avec `pacman -Qqen` etc.
- `bash/`, `git/`, `mime/` — paquets Stow (config → lien symbolique dans ~)
- `install.sh` — bootstrap complet

## Mettre à jour les listes de paquets après une install
\`\`\`
pacman -Qqen > packages/pacman.txt
pacman -Qqem > packages/aur.txt
\`\`\`
