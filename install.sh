#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> Mise à jour de la base pacman"
sudo pacman -Syu --needed

echo "==> Installation des paquets officiels"
sudo pacman -S --needed --noconfirm - < packages/pacman.txt

echo "==> Vérification de yay"
if ! command -v yay >/dev/null 2>&1; then
  echo "yay absent, compilation depuis l'AUR..."
  tmp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp_dir"
  (cd "$tmp_dir" && makepkg -si --noconfirm)
  rm -rf "$tmp_dir"
fi

echo "==> Installation des paquets AUR"
grep -vE '^\s*($|#|yay$|yay-debug$)' packages/aur.txt | sudo -u "$USER" yay -S --needed --noconfirm -

echo "==> Liaison des dotfiles (stow)"
sudo pacman -S --needed --noconfirm stow
for pkg_dir in */; do
  pkg="${pkg_dir%/}"
  [[ "$pkg" == "packages" ]] && continue
  echo "  - $pkg"
  stow -v "$pkg"
done

echo "==> Activation des services système"
mapfile -t sys_services < <(grep -v '@\.service$' packages/services-system.txt)
sudo systemctl enable --now "${sys_services[@]}"

# Les templates (ex: getty@.service) s'activent sans --now (pas d'instance à démarrer)
grep '@\.service$' packages/services-system.txt | xargs -r sudo systemctl enable

echo "==> Activation des services utilisateur"
systemctl --user enable --now $(cat packages/services-user.txt)

echo "==> Terminé."
