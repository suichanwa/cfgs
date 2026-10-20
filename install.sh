#!/usr/bin/env bash
# ==============================================================================
# Modern SwayFX Desktop Setup Installer for Arch Linux
# Repository: https://github.com/suichanwa/cfgs
# ==============================================================================

set -euo pipefail

# ANSI Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info() { echo -e "${CYAN}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.config_backup_$(date +%Y%m%d_%H%M%S)"

# 1. Sanity Checks
if [ "${EUID}" -eq 0 ]; then
    error "Please run this script as your regular user, not root (sudo will be called when needed)."
fi

if [ ! -f /etc/arch-release ]; then
    warn "This installer is tailored for Arch Linux. Other distributions may require different package names."
fi

echo -e "${CYAN}"
echo "=========================================================="
echo "    Installing Modern SwayFX Desktop Configuration        "
echo "=========================================================="
echo -e "${NC}"

# 2. Package Dependencies
OFFICIAL_PKGS=(
    # Window Manager & Wayland Essentials
    swayfx
    swaybg
    swayidle
    swaylock
    xdg-desktop-portal-wlr

    # UI Components
    waybar
    rofi
    foot
    yazi

    # Hardware & Audio
    pamixer
    pavucontrol
    btop
    brightnessctl

    # Utilities & Screen Tools
    grim
    slurp
    wl-clipboard

    # Typography & Theming
    ttf-jetbrains-mono-nerd
    noto-fonts
    breeze
    breeze-icons
    breeze-gtk
)

AUR_PKGS=(
    swaynotificationcenter
    swayosd-git
)

info "Updating package database and installing official packages..."
sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"
success "Official packages installed."

# Check for AUR helper
AUR_HELPER=""
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
fi

if [ -n "${AUR_HELPER}" ]; then
    info "Installing optional AUR packages (SwayNC, SwayOSD) using ${AUR_HELPER}..."
    ${AUR_HELPER} -S --needed --noconfirm "${AUR_PKGS[@]}" || warn "Failed to install some AUR packages, continuing..."
else
    warn "Neither yay nor paru found. Skipping optional AUR packages (${AUR_PKGS[*]})."
fi

# 3. Backup Existing Configurations
info "Creating backup of existing configurations in: ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}"

CONFIG_DIRS=(sway waybar rofi swaync swayosd foot yazi)
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "${HOME}/.config/${dir}" ]; then
        cp -r "${HOME}/.config/${dir}" "${BACKUP_DIR}/"
    fi
done

if [ -f "${HOME}/.config/helium-browser-flags.conf" ]; then
    cp "${HOME}/.config/helium-browser-flags.conf" "${BACKUP_DIR}/"
fi
success "Backup complete."

# 4. Deploy Dotfiles
info "Deploying configurations..."

# Create target directories
mkdir -p "${HOME}/.config" "${HOME}/.local/bin"

# Deploy each configuration
deploy_config() {
    local src="$1"
    local dest="$2"
    if [ -d "${REPO_DIR}/${src}" ]; then
        mkdir -p "${dest}"
        cp -rf "${REPO_DIR}/${src}/"* "${dest}/"
        success "Deployed ${src} -> ${dest}"
    elif [ -f "${REPO_DIR}/${src}" ]; then
        mkdir -p "$(dirname "${dest}")"
        cp -f "${REPO_DIR}/${src}" "${dest}"
        success "Deployed ${src} -> ${dest}"
    fi
}

deploy_config "sway" "${HOME}/.config/sway"
deploy_config "waybar" "${HOME}/.config/waybar"
deploy_config "rofi" "${HOME}/.config/rofi"
deploy_config "swaync" "${HOME}/.config/swaync"
deploy_config "swayosd" "${HOME}/.config/swayosd"
deploy_config "foot" "${HOME}/.config/foot"
deploy_config "yazi" "${HOME}/.config/yazi"
deploy_config "helium/helium-browser-flags.conf" "${HOME}/.config/helium-browser-flags.conf"

# Deploy Helper Scripts
if [ -d "${REPO_DIR}/scripts" ]; then
    cp -rf "${REPO_DIR}/scripts/"* "${HOME}/.local/bin/"
    chmod +x "${HOME}/.local/bin/"*
    success "Deployed helper scripts to ~/.local/bin/ (executable permissions set)"
fi

# 5. System Themes & Defaults
if command -v gsettings >/dev/null 2>&1; then
    info "Applying dark theme preferences..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark' || true
    gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark' || true
fi

# 6. Check PATH for ~/.local/bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    warn "~/.local/bin is not in your current PATH."
    warn "Add 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your shell rc (~/.bashrc or ~/.zshrc)."
fi

echo -e "\n${GREEN}=========================================================="
echo "    Installation and deployment finished successfully!    "
echo "==========================================================${NC}"
echo "You can launch Sway with:"
echo "    sway"
echo "To reload live in an active session:"
echo "    swaymsg reload"
